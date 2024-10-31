namespace :export do
  desc "Export files for a given Dao, Image, or Av ID or for a collection ID with file extension-based subdirectory"
  task export_files: :environment do
    require 'yaml'
    require 'fileutils'

    # Get the ID string or collection ID from the command line
    id_string = ENV['ID']
    collection_id = ENV['COLLECTION']
    force_overwrite = ENV['FORCE'] == 'true'

    # Ensure either ID or COLLECTION_ID is provided
    if id_string.nil? && collection_id.nil?
      puts "Please provide an ID by running 'rake export:export_files ID=<id_string>' or a collection ID with 'COLLECTION_ID=<collection_id>'"
      exit
    end

    log_directory = "/media/Library/ESPYderivatives/export_logs"
    FileUtils.mkdir_p(log_directory)
    log_file = File.join(log_directory, "#{collection_id || id_string}.log")

    # Retrieve the objects based on ID or collection ID
    objects = []
    if id_string
      puts "Exporting object #{id_string}..."
      # Find the single object by ID
      objects = [Dao.where(id: id_string).first ||
                 Image.where(id: id_string).first ||
                 Av.where(id: id_string).first].compact
      if objects.empty?
        puts "No object found with ID: #{id_string}"
        exit
      end
    elsif collection_id
      # Find all objects by collection_number
      puts "Exporting all objects from collection #{collection_id}..."
      objects += Dao.where(collection_number: collection_id)
      objects += Image.where(collection_number: collection_id)
      objects += Av.where(collection_number: collection_id)
      if objects.empty?
        puts "No objects found with collection ID: #{collection_id}"
        exit
      end
      File.open(log_file, 'a') { |f| f.puts("Attempting to export #{objects.count} objects for #{collection_id}...") }
    end

    successful_exports = 0

    # Iterate over each object and perform the export
    objects.each do |object|
      # Retrieve the collection_number and ID for the object
      collection_number = object.attributes['collection_number']&.to_s
      id_string = object.id.to_s
      if collection_number.nil? || collection_number.empty?
        puts "The collection_number field is missing or empty for ID #{id_string}."
        next
      end

      # Define the export directory path based on collection_number and ID
      export_directory = "/media/Library/SPE_DAO/#{collection_number}/#{id_string}/v1"

      # Check if the export directory already exists and exit unless FORCE is true
      if Dir.exist?(export_directory) && !force_overwrite
        puts "\tExport directory #{export_directory} already exists. Use 'rake export:export_files ID=<id_string> FORCE=true' to overwrite."
        next
      end

      # Create the collection-specific directory if it doesn't exist
      FileUtils.mkdir_p(export_directory)
      puts "\tExport directory created or already exists: #{export_directory}"

      # Prepare metadata for YAML
      metadata = {}

      # List of metadata fields to exclude from metadata.yml
      exclude_fields = ["depositor", "access_control_id", "admin_set_id", "lease_id", "embargo_id"]

      # Field renaming map
      rename_fields = {
        "subject" => "subjects",
        "accession" => "preservation_package",
        "date_uploaded" => "date_published"
      }

      # Fields to place at the bottom of the YAML
      bottom_fields = ["date_published", "date_modified"]

      # Collect attributes, ensuring to handle RDF::URI and lists
      object.attributes.each do |key, value|
        next if value.nil? || (value.is_a?(String) && value.empty?) ||
                  (value.respond_to?(:empty?) && value.empty?) ||
                  %w[head tail].include?(key) ||
                  exclude_fields.include?(key)

        # Rename the key if needed
        key = rename_fields[key] || key

        case value
        when ActiveTriples::Relation
          items = value.to_a.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
          if key == 'record_parent'
            metadata[key] = items # Always treat record_parent as a list
          else
            metadata[key] = items.length == 1 ? items.first.to_s : items unless items.empty?
          end
        when RDF::URI
          metadata[key] = value.to_s
        when Array
          filtered_items = value.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
          metadata[key] = filtered_items unless filtered_items.empty?
        else
          metadata[key] = value.to_s
        end
      end

      # Move the fields in `bottom_fields` to the bottom of the YAML
      metadata = metadata.sort_by { |key, _| bottom_fields.include?(key) ? 1 : 0 }.to_h



      # Always include record_parent in the metadata as a list
      record_parent_value = object.attributes['record_parent']
      metadata['record_parent'] = record_parent_value.is_a?(ActiveTriples::Relation) ? 
                                    record_parent_value.to_a.reject(&:nil?) : []

      # Handle the license field
      license_value = object.attributes['license']
      license_items = license_value.is_a?(ActiveTriples::Relation) ? license_value.to_a.reject(&:nil?) : []
      metadata['license'] = if license_items.empty?
                               ""
                             elsif license_items.length == 1
                               license_items.first.to_s
                             else
                               license_items.map(&:to_s)
                             end

      # Replace "http://" with "https://" in license, if it exists
      metadata['license'] = metadata['license'].gsub('http://', 'https://') unless metadata['license'].nil?

      # If license is empty or "Unknown", handle rights_statement; otherwise, skip it
      if metadata['license'].empty? || metadata['license'] == "Unknown"
        # Set default license to "Unknown" if it’s empty
        metadata['license'] = "Unknown" if metadata['license'].empty?

        # Handle the rights_statement field
        rights_statement_value = object.attributes['rights_statement']
        rights_statement_items = rights_statement_value.is_a?(ActiveTriples::Relation) ? rights_statement_value.to_a.reject(&:nil?) : []
        metadata['rights_statement'] = if rights_statement_items.empty?
                                           "https://rightsstatements.org/page/InC-EDU/1.0/"
                                         elsif rights_statement_items.length == 1
                                           rights_statement_items.first.to_s
                                         else
                                           rights_statement_items.map(&:to_s)
                                         end

        # Replace "http://" with "https://" in rights_statement, if it exists
        metadata['rights_statement'] = metadata['rights_statement'].gsub('http://', 'https://') unless metadata['rights_statement'].nil?
      end

      file_set_data = {} # Hash to store file_set_id => filename pairs

      # Process each file and sort them into extension-based folders
      object.file_sets.each do |file_set|
        begin
          filename = file_set.attributes["title"][0].dup.force_encoding('ASCII-8BIT')
          puts "\t\tProcessing file: #{filename}"

          # Determine the extension
          file_extension = File.extname(filename).downcase.sub('.', '')

          # Build file set dict for metadata.yml
          file_set_data[file_set.id] = filename
          # Set original_file and original_format
          if file_set.id == object.representative_id
            metadata["original_file_legacy"] = filename
            if filename.downcase.end_with?('.pdf')
              metadata["behavior"] = "paged"
            else
              metadata["behavior"] = "individuals"
            end
          end

          # Skip video files except for .webm
          next if %w[mov mp4 avi].include?(file_extension) # add more extensions if needed
          # Continue with webm files or other types
          puts "\t\tExporting file: #{filename}"

          # Create the subdirectory for the extension
          extension_directory = File.join(export_directory, file_extension)
          FileUtils.mkdir_p(extension_directory)

          if file_set.files.any?
            file_path = File.join(extension_directory, filename)

            # Write in chunks to avoid memory overload
            File.open(file_path, 'wb') do |output_file|
              file_set.files.each do |file|
                binary_content = file.content.force_encoding('ASCII-8BIT')

                # Write in chunks to avoid memory overload
                buffer_size = 1024 * 1024 # 1MB
                offset = 0
                while offset < binary_content.bytesize
                  chunk = binary_content[offset, buffer_size]
                  output_file.write(chunk)
                  offset += buffer_size
                end
              end
            end

            puts "\t\tExported file: #{file_path}"
          else
            puts "\t\tNo files present for file set ID: #{file_set.id}"
          end
        rescue NoMemoryError => e
          puts "\t\tMemory error processing file set ID #{file_set.id}: #{e.message}. Skipping this file set."
          next # Continue to the next file set
        rescue StandardError => e
          puts "\t\tError processing file set ID #{file_set.id}: #{e.message}"
          # Optionally log the full error for debugging
          # logger.error(e.backtrace.join("\n"))
        end
      end


      # Add list of file set ids to metadata.yml
      metadata["file_sets"] = file_set_data

      # Write attributes to metadata.yml
      metadata_file_path = File.join(export_directory, "metadata.yml")
      File.open(metadata_file_path, 'w') do |metadata_file|
        metadata_file.write(metadata.to_yaml)
      end
      #puts "\tMetadata written to #{metadata_file_path}"

      puts "\tExport completed for ID #{id_string}."
      successful_exports += 1
      File.open(log_file, 'a') { |f| f.puts("\t --> Exported #{id_string} successfully") }
    end
    if collection_id
      File.open(log_file, 'a') do |f|
        f.puts("Total successful exports: #{successful_exports} for collection #{collection_id}")
      end
    end
  end
end
