namespace :export do
  desc "Export files for a given Dao, Image, or Av ID with file extension-based subdirectory"
  task export_files: :environment do
    require 'yaml' # Require YAML for writing the metadata file

    # Get the ID string from the command line
    id_string = ENV['ID']

    # Ensure an ID was provided
    if id_string.nil?
      puts "Please provide an ID by running 'rake export:export_files ID=<id_string>'"
      exit
    end

    # Attempt to find the object using the provided ID
    object = Dao.where(id: id_string).first ||
             Image.where(id: id_string).first ||
             Av.where(id: id_string).first

    unless object
      puts "No object found with ID: #{id_string}"
      exit
    end

    # Retrieve the collection_number for the object
    collection_number = object.attributes['collection_number']&.to_s
    if collection_number.nil? || collection_number.empty?
      puts "The collection_number field is missing or empty for ID #{id_string}."
      exit
    end

    # Define the export directory path based on collection_number
    export_directory = "/media/Library/SPE_DAO/#{collection_number}/#{id_string}/v1"

    # Create the collection-specific directory if it doesn't exist
    FileUtils.mkdir_p(export_directory) unless Dir.exist?(export_directory)
    puts "Export directory created or already exists: #{export_directory}"

    # Prepare metadata for YAML
    metadata = {}

    # Collect attributes, ensuring to handle RDF::URI and lists
    object.attributes.each do |key, value|
      next if value.nil? || (value.is_a?(String) && value.empty?) ||
                (value.respond_to?(:empty?) && value.empty?) ||
                %w[head tail].include?(key) # Skip head and tail fields

      # Handle ActiveTriples::Relation (lists) specifically
      if value.is_a?(ActiveTriples::Relation)
        # Always treat record_parent as a list
        if key == 'record_parent'
          metadata[key] = value.to_a.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
        else
          # Check if there's only one item in the relation
          items = value.to_a.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
          metadata[key] = items.length == 1 ? items.first.to_s : items unless items.empty?
        end
      elsif value.is_a?(RDF::URI)
        metadata[key] = value.to_s
      elsif value.is_a?(Array)
        metadata[key] = value.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
      else
        metadata[key] = value.to_s
      end
    end

    # Always include record_parent in the metadata as a list
    record_parent_value = object.attributes['record_parent']
    metadata['record_parent'] = record_parent_value.is_a?(ActiveTriples::Relation) ? 
                                  record_parent_value.to_a.reject(&:nil?) : []

    # Handle the license field
    license_value = object.attributes['license']
    if license_value.is_a?(ActiveTriples::Relation)
      items = license_value.to_a.reject(&:nil?)
      metadata['license'] = if items.empty?
                               ""
                             elsif items.length == 1
                               items.first.to_s
                             else
                               items.map(&:to_s)
                             end
    end

    # Get thumbnail file_set id
    metadata['thumbnail_id'] = object.thumbnail.id

    # Handle the rights_statement field
    rights_statement_value = object.attributes['rights_statement']
    if rights_statement_value.is_a?(ActiveTriples::Relation)
      items = rights_statement_value.to_a.reject(&:nil?)
      metadata['rights_statement'] = if items.empty?
                                         ""
                                       elsif items.length == 1
                                         items.first.to_s
                                       else
                                         items.map(&:to_s)
                                       end
    end

    # Write attributes to metadata.yml
    metadata_file_path = File.join(export_directory, "metadata.yml")
    File.open(metadata_file_path, 'w') do |metadata_file|
      metadata_file.write(metadata.to_yaml)
    end
    puts "Metadata written to #{metadata_file_path}"

    # Ensure that all file extensions are the same
    file_extensions = object.file_sets.map do |file_set|
      filename = file_set.attributes["title"][0]
      puts "Processing filename: #{filename}"

      next if filename.nil? || filename.empty?

      File.extname(filename).downcase.sub('.', '')
    end.compact.uniq

    if file_extensions.length > 1
      raise "Files have different extensions: #{file_extensions.join(', ')}. Unable to continue."
    elsif file_extensions.empty?
      raise "No valid filenames found in the file sets."
    end

    # Use the common extension for subdirectory naming
    file_extension = file_extensions.first
    extension_directory = File.join(export_directory, file_extension)

    FileUtils.mkdir_p(extension_directory) unless Dir.exist?(extension_directory)
    puts "Subdirectory for extension '#{file_extension}' created: #{extension_directory}"

    object.file_sets.each do |file_set|
    filename = file_set.attributes["title"][0]
    puts "\tExporting file: #{filename}"

    require 'tempfile'
    if file_set.files.any?
      binary_content = file_set.files[0].content.force_encoding('ASCII-8BIT')
      Tempfile.open do |temp|
        temp.write(binary_content)
        temp.rewind
        file_path = File.join(extension_directory, filename)
        File.open(file_path, 'wb') do |file|
          IO.copy_stream(temp, file)
        end
      end

      puts "Exported file: #{file_path}"
    else
      # Handle case where no files are present
    end
  end

    puts "Export completed for ID #{id_string}."
  end
end
