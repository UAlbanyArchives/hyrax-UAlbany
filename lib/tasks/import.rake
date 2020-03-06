require 'csv'
require 'fileutils'

namespace :import do
  desc "TODO"
  
    def ingest_work(model, item_attributes, depositor)
        if model.downcase == "av"
            obj = Av.new
        elsif model.downcase == "image"
            obj = Image.new
        else
            obj = Dao.new
        end
        obj.apply_depositor_metadata(depositor)
        #puts item_attributes
        obj.attributes = item_attributes
        obj.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        
        now = Hyrax::TimeService.time_in_utc
        obj.date_uploaded = now
        
        direct_upload = AdminSet.find("mp48sc763")
        obj.admin_set = direct_upload
        resp = obj.save
        
        return obj
    end

    def attach_files(work, import_files, user)
                
        files = []
        files += [import_files] if import_files
		
        import_files.each do |f|
            fs = FileSet.new
			
			puts "\t\tUploading " + File.basename(f)
                       
            fs.title = [File.basename(f)]
            fs.set_edit_groups(["content-admin"],[])
            actor = ::Hyrax::Actors::FileSetActor.new(fs, user)
            actor.create_metadata()
            actor.create_content(File.open(f))
            actor.attach_to_work(work)
            
        end
    end
  
    task sheet: :environment do     

        depositor = "importer@albany.edu"
        user = User.find_by_user_key(depositor)
        
        importPath = "/media/Library/ESPYderivatives/import"
        completePath = "/media/Library/ESPYderivatives/complete"
        finishPath = "/media/Library/ESPYderivatives/used"
        binaryPath = "/media/Library/ESPYderivatives/files"
        Dir.foreach(importPath) do |sheet|
            if sheet.end_with? ".tsv"
				puts "\t" + Time.now.to_s + " Reading sheet: " + sheet
			
                filePath = File.join(importPath, sheet)
                begin
                    file = File.open(filePath)
                    headers = CSV.parse(file, headers: true, col_sep: "\t").headers
                rescue
                    file = File.open(filePath, "r:ISO-8859-1")
                    headers = CSV.parse(file, headers: true, encoding: 'windows-1251:utf-8', col_sep: "\t").headers
                end
                if File.file?(filePath)
                    CSV.open(File.join(completePath, sheet), "ab", {col_sep: "\t"}) do |outputFile|
                        outputFile << headers
                    end
                end
                file.close
                
                begin
                    file = File.open(filePath)
                    importData = CSV.parse(file, headers: true, col_sep: "\t", skip_blanks: true).reject { |row| row.all?(&:nil?) } 
                rescue
                    file = File.open(filePath, "r:ISO-8859-1")
                    importData = CSV.parse(file, headers: true, col_sep: "\t", skip_blanks: true).reject { |row| row.all?(&:nil?) } 
                end
                
                importData.each do |row|
                
                    item_attributes = {}
                    import_files = []
                    file_list = []
                    
                    clean_files = row[2]
                    clean_files.strip!
                    file_list = clean_files.split('|')
                    #puts file_list
                    file_list.each do |filename|
                        if File.file?(File.join(binaryPath, row[5], filename))
                            import_files << File.join(binaryPath, row[5], filename)			
                        else
                            import_files << File.join(binaryPath, filename)
                        end
                    end
                    #puts import_files
                    
                    item_attributes['accession'] = [row[3]]
                    item_attributes['collecting_area'] = row[4]
                    item_attributes['collection_number'] = row[5]
                    item_attributes['collection'] = row[6]
                    item_attributes['archivesspace_record'] = row[7] if row[7].respond_to? :length
                    item_attributes['record_parent'] = row[8].split('|') if row[8].respond_to? :length
                    item_attributes['title'] = [row[9]]
                    item_attributes['description'] = [row[10]] if row[10].respond_to? :length
                    item_attributes['date_created'] = [row[11]]
                    item_attributes['resource_type'] = [row[12]]
                    item_attributes['license'] = [row[13]]
                    item_attributes['rights_statement'] = [row[14]] if row[14].respond_to? :length
                    item_attributes['subject'] = row[15].split('|') if row[15].respond_to? :length
                    
                    outputFile = CSV.open(File.join(completePath, sheet), "ab", {col_sep: "\t"})
                    if row[0].downcase == "av"
                    
                        item_attributes['creator'] = row[16].split("|")
                        item_attributes['identifier'] = [row[17]]
                        item_attributes['contributor'] = [row[18]]
                        item_attributes['master_format'] = row[19] if row[19].respond_to? :length
                        item_attributes['date_digitized'] = row[20] if row[20].respond_to? :length
                        item_attributes['source'] = [row[23]] if row[23].respond_to? :length
                        item_attributes['extent'] = row[21].split('|') if row[21].respond_to? :length
                        item_attributes['physical_dimensions'] = row[22] if row[22].respond_to? :length
			item_attributes['processing_activity'] = [row[24]] if row[24].respond_to? :length
                        
                        #puts item_attributes
                        puts "\tIngesting " + item_attributes['title'][0]
						if row[7].respond_to? :length
							puts "\t\tASpace: " + row[7]
						else
							puts "\t\tIdentifier: " + row[17] if row[17].respond_to? :length
						end
                        
                        obj = ingest_work("av", item_attributes, depositor)
                        new_uri = "avs/" + obj.id

                        puts "\t\tnow: " + new_uri
                        row[1] = new_uri
                        outputFile << row
                        
                    
                    elsif row[0].downcase == "image"
                    
                        item_attributes['creator'] = row[16].split("|")
                        item_attributes['identifier'] = [row[17]]
                        item_attributes['contributor'] = [row[18]]
                        item_attributes['master_format'] = row[19] if row[19].respond_to? :length
                        item_attributes['date_digitized'] = row[20] if row[20].respond_to? :length
                        
                        #puts item_attributes
                        puts "Uploading " + item_attributes['title'][0]
						if row[7].respond_to? :length
							puts "\t\tASpace: " + row[7]
						else
							puts "\t\tIdentifier: " + row[17] if row[17].respond_to? :length
						end
                        
                        obj = ingest_work("image", item_attributes, depositor)
                        new_uri = "images/" + obj.id

                        puts "\t\tnow: " + new_uri
                        row[1] = new_uri
                        outputFile << row
                       
                    
                    else
                    
                        item_attributes['coverage'] = row[16].downcase
                        item_attributes['processing_activity'] = row[17].split('|') if row[17].respond_to? :length
                        item_attributes['extent'] = row[18].split('|') if row[18].respond_to? :length
                        item_attributes['language'] = [row[19]] if row[19].respond_to? :length
                    
                        #puts item_attributes
                        puts "Uploading " + item_attributes['title'][0]
                        puts "\t\tASpace: " + row[7] if row[7].respond_to? :length
                        
                        obj = ingest_work("dao", item_attributes, depositor)
                        new_uri = "daos/" + obj.id

                        puts "\t\tnow: " + new_uri
                        row[1] = new_uri
                        outputFile << row
                        
                    
                    end
                    outputFile.close
                    
                    attach_files(obj, import_files, user)
                    puts "\t\tSuccess!"
                
                end                
                file.close   
                
         
                FileUtils.mv(filePath, finishPath)
            end
        end   

    end
    
    task check: :environment do     
       
        importPath = "/media/Library/ESPYderivatives/import"
        binaryPath = "/media/Library/ESPYderivatives/files"
        Dir.foreach(importPath) do |sheet|
        
            errors = 0
            if sheet.end_with? ".tsv"
				puts "\t" + Time.now.to_s + " Reading sheet: " + sheet
			
                filePath = File.join(importPath, sheet)                
                begin
                    file = File.open(filePath)
                    importData = CSV.parse(file, headers: true, col_sep: "\t", skip_blanks: true).reject { |row| row.all?(&:nil?) } 
                rescue
                    file = File.open(filePath, "r:ISO-8859-1")
                    importData = CSV.parse(file, headers: true, col_sep: "\t", skip_blanks: true).reject { |row| row.all?(&:nil?) } 
                end
                
                importData.each do |row|
                
                    file_list = []
                    
                    clean_files = row[2]
                    clean_files.strip!
                    file_list = clean_files.split('|')
                    #puts file_list
                    file_list.each do |filename|
                        #puts "Checking for " + filename.to_s
                        if File.file?(File.join(binaryPath, row[5], filename))		
                        elsif File.file?(File.join(binaryPath, filename))
                        else
                            errors += 1
                            puts "ERROR: " + filename.to_s + " does not exist in " + binaryPath.to_s
                        end
                    end
                    
                end                
                file.close                  
                
            end
            if errors < 1
               puts "Success! All files look good to go."
            end
        end   

    end
    
    task files: :environment do
    
        depositor = "importer@albany.edu"
        user = User.find_by_user_key(depositor)
        
        binaryPath = "/media/Library/ESPYderivatives/files"
        
        dao = Dao.find(ENV["object"])
        
        import_files = []
        ENV["files"].split("|").each do |filename|
            import_files << File.join(binaryPath, filename)
        end
        
        attach_files(dao, import_files, user)
        puts "-->  Success!"
            
    end
    
end



