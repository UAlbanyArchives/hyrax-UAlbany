namespace :export do
  desc "Export files for a given Dao ID with file extension-based subdirectory"
  task export_files: :environment do
    require 'yaml' # Require YAML for writing the metadata file

    # Get the ID string from the command line
    id_string = ENV['ID']

    # Ensure an ID was provided
    if id_string.nil?
      puts "Please provide an ID by running 'rake export:export_files ID=<id_string>'"
      exit
    end

    # Define the export directory path
    export_directory = "/media/Library/ESPYderivatives/exports/#{id_string}"

    # Create the directory if it doesn't exist
    FileUtils.mkdir_p(export_directory) unless Dir.exist?(export_directory)
    puts "Export directory created or already exists: #{export_directory}"

    # Find the Dao object using the provided ID
    dao = Dao.find(id_string)

    # Prepare metadata for YAML
    metadata = {}

    # Collect attributes, ensuring to handle RDF::URI and lists
    dao.attributes.each do |key, value|
      next if value.nil? || (value.is_a?(String) && value.empty?) || (value.respond_to?(:empty?) && value.empty?)

      # Handle RDF::URI and convert to string
      if value.is_a?(RDF::URI)
        metadata[key] = value.to_s
      elsif value.is_a?(Array)
        # If it's an array, include it as-is (YAML will handle arrays)
        metadata[key] = value.reject { |v| v.nil? || (v.is_a?(String) && v.empty?) }
      else
        # Convert all other types to string
        metadata[key] = value.to_s
      end
    end

    # Write Dao attributes to metadata.yml
    metadata_file_path = File.join(export_directory, "metadata.yml")
    File.open(metadata_file_path, 'w') do |metadata_file|
      metadata_file.write(metadata.to_yaml)
    end
    puts "Metadata written to #{metadata_file_path}"

    # Ensure that all file extensions are the same
    file_extensions = dao.file_sets.map do |file_set|
      # Extract the filename from the file set's title attribute
      filename = file_set.attributes["title"][0]
      
      # Debugging output
      puts "Processing filename: #{filename}"

      # Validate filename
      next if filename.nil? || filename.empty?

      # Extract and return the file extension
      File.extname(filename).downcase.sub('.', '') # Get the file extension without the dot
    end.compact.uniq # Remove nil values and get unique extensions

    # If there are multiple unique extensions, raise an error
    if file_extensions.length > 1
      raise "Files have different extensions: #{file_extensions.join(', ')}. Unable to continue."
    elsif file_extensions.empty?
      raise "No valid filenames found in the file sets."
    end

    # Use the common extension for subdirectory naming
    file_extension = file_extensions.first
    extension_directory = File.join(export_directory, file_extension)

    # Create the subdirectory for the extension
    FileUtils.mkdir_p(extension_directory) unless Dir.exist?(extension_directory)
    puts "Subdirectory for extension '#{file_extension}' created: #{extension_directory}"

    # Iterate over each file set
    dao.file_sets.each do |file_set|
      # Get the file name from the file set's title attribute
      filename = file_set.attributes["title"]
      
      # Debugging output
      puts "Exporting file: #{filename}"

      # Get the binary content from the first file in the file set
      if file_set.files.any?
        binary_content = file_set.files[0].content

        # Define the file path within the extension directory
        file_path = File.join(extension_directory, filename)

        # Write the binary content to the file
        File.open(file_path, 'wb') do |file|
          file.write(binary_content)
        end

        puts "Exported file: #{file_path}"
      else
        puts "No files found in file set for #{filename}"
      end
    end

    puts "Export completed for Dao ID #{id_string}."
  end
end
