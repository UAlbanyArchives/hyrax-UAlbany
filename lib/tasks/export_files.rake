namespace :export do
  desc "Export files for a given Dao, Image, or Av ID, a collection ID, or a list of collection IDs with file extension-based subdirectory"
  task export_files: :environment do
    require 'yaml'
    require 'fileutils'
    require 'net/http'
    require 'json'

    id_string = ENV['ID']
    collection_id = ENV['COLLECTION']
    collection_ids_list = ENV['COLLECTIONS']
    force_overwrite = ENV['FORCE'] == 'true'

    if id_string.nil? && collection_id.nil? && collection_ids_list.nil?
      puts "Please provide an ID, a collection ID, or a list of collection IDs. Example usage:"
      puts "  rake export:export_files ID=<id_string>"
      puts "  rake export:export_files COLLECTION=<collection_id>"
      puts "  rake export:export_files COLLECTIONS=<collection_id1,collection_id2,...>"
      exit
    end

    log_directory = "/media/Library/ESPYderivatives/export_logs"
    FileUtils.mkdir_p(log_directory)

    collection_ids = []
    if collection_ids_list
      collection_ids = collection_ids_list.split(',').map(&:strip)
    elsif collection_id
      collection_ids << collection_id
    end

    object_ids = []
    if id_string
      object_ids << id_string
      log_file = File.join(log_directory, "#{id_string}.log")
    end

    collection_ids.each do |current_collection_id|
      log_file = File.join(log_directory, "#{current_collection_id}.log")
      start = 0
      rows = 100

      begin
        solr_url = "https://solr2020.library.albany.edu:8984/solr/hyrax/select?q=collection_number_sim:#{current_collection_id}&rows=#{rows}&start=#{start}&wt=json"
        uri = URI(solr_url)
        response = Net::HTTP.get(uri)
        json_response = JSON.parse(response)
        num_found = json_response['response']['numFound']
        docs = json_response['response']['docs']
        object_ids += docs.map { |doc| doc['id'] }
        start += rows
      end while start < num_found

      if object_ids.empty?
        puts "No objects found with collection ID: #{current_collection_id}"
      end
    end

    if object_ids.empty?
      puts "No objects found to export."
      exit
    end

    successful_exports = 0

    object_ids.each do |object_id|
      # The logic for exporting individual objects remains the same.
      # You can copy your existing logic here to process `object_id`.
    end

    puts "Export completed. Total successful exports: #{successful_exports}"
  end
end
