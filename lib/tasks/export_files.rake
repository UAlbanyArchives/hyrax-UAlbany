namespace :export do
  desc "Export files for a given Dao, Image, or Av ID or for a collection ID with file extension-based subdirectory"
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
    log_file = nil

    if id_string
      object_ids << id_string
      log_file = File.join(log_directory, "#{id_string}.log")
    else
      puts "getting object ids..."
      collection_ids.each do |collection_id|
        log_file = File.join(log_directory, "#{collection_id}.log")
        start = 0
        rows = 100

        begin
          solr_url = "https://solr2020.library.albany.edu:8984/solr/hyrax/select?fq=has_model_ssim:(Dao OR Av OR Image)&fq=system_modified_dtsi:[2025-01-01T00:00:00Z TO 2025-04-30T23:59:59Z]&rows=#{rows}&start=#{start}&wt=json"
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
          exit
        end
      end
    end

    successful_exports = 0

    object_ids.each do |object_id|
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
            next
          end
        end
      end

      collection_number = object.attributes['collection_number']&.to_s
      id_string = object.id.to_s
      if collection_number.nil? || collection_number.empty?
        puts "The collection_number field is missing or empty for ID #{id_string}."
        next
      end

      export_directory = "/media/Library/SPE_DAO/aa_migration/#{collection_number}/#{id_string}"
      if Dir.exist?(export_directory) && !force_overwrite
        puts "\tExport directory #{export_directory} already exists. Use 'rake export:export_files ID=<id_string> FORCE=true' to overwrite."
        next
      end

      FileUtils.mkdir_p(export_directory)

      metadata = {}
      exclude_fields = ["record_parent", "thumbnail_id", "depositor", "access_control_id", "admin_set_id", "lease_id", "embargo_id", "date_modified"]
      rename_fields = { "subject" => "subjects", "accession" => "preservation_package", "date_uploaded" => "date_published", "date_created" => "date_display" }
      bottom_fields = ["date_published"]


      # Process other attributes
      object.attributes.each do |key, value|
        next if value.nil? || (value.is_a?(String) && value.empty?) ||
                  (value.respond_to?(:empty?) && value.empty?) ||
                  %w[head tail].include?(key) ||
                  exclude_fields.include?(key)

        # Check for visibility and log if it's not open
        if key == 'visibility' && value != "open"
          metadata['visibility'] = "closed"
        else

          key = rename_fields[key] || key

          case value
          when ActiveTriples::Relation
            items = value.to_a.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
            metadata[key] = items.length == 1 ? items.first.to_s : items unless items.empty?
          when RDF::URI
            metadata[key] = value.to_s
          when Array
            filtered_items = value.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
            metadata[key] = filtered_items unless filtered_items.empty?
          else
            metadata[key] = value.to_s
          end
        end
      end
      

      metadata["date_structured"] = ""
      metadata = metadata.sort_by { |key, _| bottom_fields.include?(key) ? 1 : 0 }.to_h

      license_value = object.attributes['license']
      license_items = license_value.is_a?(ActiveTriples::Relation) ? license_value.to_a.reject(&:nil?) : []
      metadata['license'] = license_items.empty? ? "" : license_items.map(&:to_s).join(", ")

      if metadata['license'].empty? || metadata['license'] == "Unknown"
        metadata['license'] = "Unknown" if metadata['license'].empty?

        rights_statement_value = object.attributes['rights_statement']
        rights_statement_items = rights_statement_value.is_a?(ActiveTriples::Relation) ? rights_statement_value.to_a.reject(&:nil?) : []
        metadata['rights_statement'] = rights_statement_items.empty? ? "https://rightsstatements.org/page/InC-EDU/1.0/" : rights_statement_items.map(&:to_s).join(', ')
        metadata['rights_statement'] = metadata['rights_statement'].gsub('http://', 'https://')
      end

      file_set_data = {}
      object.file_sets.each do |file_set|
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
  end
end
