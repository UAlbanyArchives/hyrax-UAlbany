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
    puts collection_ids
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
              begin
          filename = file_set.attributes["title"][0]#.dup.force_encoding('ASCII-8BIT')
          puts "\tProcessing file: #{filename}"
          # Determine the extension
          file_extension = File.extname(filename).downcase.sub('.', '')
          # Build file set dict for metadata.yml
          file_set_data[file_set.id] = filename
          # Set original_file and original_format
          if file_set.id == object.representative_id
            metadata["original_file_legacy"] = filename
            metadata["behavior"] = filename.downcase.end_with?('.pdf') ? "paged" : "individuals"
          end
          # Skip exporting non-open files
          if object.attributes['visibility'] != "open"
            log_msg = "\t! Skipping file export for #{object.id}, visibility not open\n"
            log_msg << (collection_id ? "\t --> Exported #{id_string} successfully" : "Exported #{id_string} successfully")
            File.open(log_file, 'a') { |f| f.puts(log_msg) }
          # Skip video files except for .webm
          elsif %w[mov mp4 avi].include?(file_extension) # add more extensions if needed
            log_msg = "\t! Skipping video file export for #{object.id}\n"
            log_msg << (collection_id ? "\t --> Exported #{id_string} successfully" : "Exported #{id_string} successfully")
            File.open(log_file, 'a') { |f| f.puts(log_msg) }
          else
            puts "\tExporting file: #{filename}"
            # Create the subdirectory for the extension
            extension_directory = File.join(export_directory, file_extension)
            FileUtils.mkdir_p(extension_directory)
            if file_set.files.any?
              file_path = File.join(extension_directory, filename)
              # Only rescue errors in this specific file-writing block
              begin
                # Retrieve the binary content directly
                file_set.files.each do |file|
                  # some .doc and .rtf files are incorrectly listed as utf-8 encoded?
                  if File.extname(file_path).downcase == '.doc' || File.extname(file_path).downcase == '.rtf' || file.content.encoding == Encoding::ASCII_8BIT
                    # Write the binary content to a file in binary mode
                    File.open(file_path, 'wb') do |output_file|
                      output_file.write(file.content)
                    end
                  end
                end
                puts "\tFile exported: #{file_path}"
                successful_exports += 1
                # Log the successful export
                log_msg = collection_id ? "\t --> Exported #{id_string} successfully" : "Exported #{id_string} successfully"
                File.open(log_file, 'a') { |f| f.puts(log_msg) }
              rescue NoMemoryError => e
                puts "Memory error encountered while exporting #{filename}: #{e.message}. Skipping file."
                #next
              rescue StandardError => e
                puts "Error encountered while exporting #{filename}: #{e.message}. Skipping file."
                #next
              end
            end
          end
        end
      end
      # Add list of file set ids to metadata.yml
      metadata["file_sets"] = file_set_data
      
      # Write attributes to metadata.yml
      metadata_file_path = File.join(export_directory, "metadata.yml")
      File.open(metadata_file_path, 'w') do |metadata_file|
        metadata_file.write(metadata.to_yaml)
      end
      puts "\tMetadata written to #{metadata_file_path}"
      puts "\tExport completed for ID #{id_string}."
    end

    puts "Export completed. Total successful exports: #{successful_exports}"
  end
end
