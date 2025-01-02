namespace :export do
  desc "Export files for a given Dao, Image, or Av ID, collection ID, or a list of collection IDs with file extension-based subdirectory"
  task export_files: :environment do
    require 'yaml'
    require 'fileutils'
    require 'net/http'
    require 'json'

    id_string = ENV['ID']
    collection_id = ENV['COLLECTION']
    collection_list = ENV['COLLECTION_LIST']
    force_overwrite = ENV['FORCE'] == 'true'

    if id_string.nil? && collection_id.nil? && collection_list.nil?
      puts "Please provide an ID, COLLECTION, or COLLECTION_LIST by running one of the following:"
      puts "'rake export:export_files ID=<id_string>'"
      puts "'rake export:export_files COLLECTION=<collection_id>'"
      puts "'rake export:export_files COLLECTION_LIST=<collection_id1,collection_id2,...>'"
      exit
    end

    log_directory = "/media/Library/ESPYderivatives/export_logs"
    FileUtils.mkdir_p(log_directory)

    object_ids = []
    log_file = nil

    if id_string
      object_ids << id_string
      log_file = File.join(log_directory, "#{id_string}.log")
    elsif collection_id
      log_file = File.join(log_directory, "#{collection_id}.log")
      object_ids += fetch_object_ids_by_collection(collection_id)
    elsif collection_list
      collection_ids = collection_list.split(',')
      log_file = File.join(log_directory, "collection_list.log")
      collection_ids.each do |col_id|
        object_ids += fetch_object_ids_by_collection(col_id)
      end
    end

    if object_ids.empty?
      puts "No objects found for the provided ID(s)."
      exit
    end

    successful_exports = 0

    object_ids.each do |object_id|
      export_object(object_id, force_overwrite, log_file)
    end

    puts "Export completed. #{successful_exports} objects were successfully exported."
  end

  # Helper method to fetch object IDs for a given collection ID from Solr
  def fetch_object_ids_by_collection(collection_id)
    start = 0
    rows = 100
    object_ids = []

    begin
      solr_url = "https://solr2020.library.albany.edu:8984/solr/hyrax/select?q=collection_number_sim:#{collection_id}&rows=#{rows}&start=#{start}&wt=json"
      uri = URI(solr_url)
      response = Net::HTTP.get(uri)
      json_response = JSON.parse(response)
      num_found = json_response['response']['numFound']
      docs = json_response['response']['docs']
      object_ids += docs.map { |doc| doc['id'] }
      start += rows
    end while start < num_found

    if object_ids.empty?
      puts "No objects found with collection ID: #{collection_id}"
    end

    object_ids
  end

  # Helper method to export a single object
  def export_object(object_id, force_overwrite, log_file)
    object = find_object_by_id(object_id)
    return unless object

    collection_number = object.attributes['collection_number']&.to_s
    id_string = object.id.to_s
    if collection_number.nil? || collection_number.empty?
      puts "The collection_number field is missing or empty for ID #{id_string}."
      return
    end

    export_directory = "/media/Library/SPE_DAO/#{collection_number}/#{id_string}"
    if Dir.exist?(export_directory) && !force_overwrite
      puts "\tExport directory #{export_directory} already exists. Use FORCE=true to overwrite."
      return
    end

    FileUtils.mkdir_p(export_directory)

    metadata = prepare_metadata(object)
    file_set_data = process_file_sets(object, export_directory)

    metadata["file_sets"] = file_set_data

    metadata_file_path = File.join(export_directory, "metadata.yml")
    File.open(metadata_file_path, 'w') do |metadata_file|
      metadata_file.write(metadata.to_yaml)
    end
    puts "\tMetadata written to #{metadata_file_path}"

    puts "\tExport completed for ID #{id_string}."
  end

  # Helper method to find an object by ID
  def find_object_by_id(object_id)
    object = nil
    begin
      object = Dao.find(object_id)
    rescue ActiveFedora::ObjectNotFoundError, ActiveFedora::ModelMismatch
      begin
        object = Image.find(object_id)
      rescue ActiveFedora::ObjectNotFoundError, ActiveFedora::ModelMismatch
        begin
          object = Av.find(object_id)
        rescue ActiveFedora::ObjectNotFoundError
          puts "No object found with ID: #{object_id}"
        end
      end
    end
    object
  end

  # Helper method to prepare metadata for an object
  def prepare_metadata(object)
    metadata = {}
    exclude_fields = ["record_parent", "thumbnail_id", "depositor", "access_control_id", "admin_set_id", "lease_id", "embargo_id", "date_modified"]
    rename_fields = { "subject" => "subjects", "accession" => "preservation_package", "date_uploaded" => "date_published", "date_created" => "date_display" }
    bottom_fields = ["date_published"]

    object.attributes.each do |key, value|
      next if value.nil? || value.to_s.strip.empty? || exclude_fields.include?(key)

      key = rename_fields[key] || key
      metadata[key] = value.is_a?(Array) ? value.reject(&:blank?) : value
    end

    metadata["date_structured"] = ""
    metadata = metadata.sort_by { |key, _| bottom_fields.include?(key) ? 1 : 0 }.to_h

    license_value = object.attributes['license']
    metadata['license'] = license_value.is_a?(Array) ? license_value.reject(&:nil?).join(", ") : license_value.to_s

    rights_statement_value = object.attributes['rights_statement']
    metadata['rights_statement'] = rights_statement_value.is_a?(Array) ? rights_statement_value.reject(&:nil?).join(', ') : rights_statement_value.to_s

    metadata
  end

  # Helper method to process file sets for an object
  def process_file_sets(object, export_directory)
    file_set_data = {}
    object.file_sets.each do |file_set|
      filename = file_set.attributes["title"].first
      file_extension = File.extname(filename).downcase.sub('.', '')

      next if %w[mov mp4 avi].include?(file_extension) && file_extension != 'webm'

      extension_directory = File.join(export_directory, file_extension)
      FileUtils.mkdir_p(extension_directory)

      file_path = File.join(extension_directory, filename)
      File.open(file_path, 'wb') do |output_file|
        output_file.write(file_set.files.first.content)
      end

      file_set_data[file_set.id] = filename
    end
    file_set_data
  end
end
