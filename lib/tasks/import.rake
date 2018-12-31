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
        
        return obj.id
    end

    def attach_files(work, import_files, depositor)
            
        user = User.find_by_user_key(depositor)
        
        files = []
        files += [import_files] if import_files
		
        import_files.each do |f|
            fs = FileSet.new
			
			puts "\t\tUploading " + File.basename(f)
                       
            fs.title = [File.basename(f)]
            actor = ::Hyrax::Actors::FileSetActor.new(fs, user)
            actor.create_metadata()
            actor.create_content(File.open(f))
            actor.attach_to_work(work)
            fs.set_edit_groups(["content-admin"],[])
            
            fs.save            
        end
    end
  
    task sheet: :environment do     

        depositor = "importer@albany.edu"
        importPath = "/media/Library/ESPYderivatives/import"
        completePath = "/media/Library/ESPYderivatives/complete"
        finishPath = "/media/Library/ESPYderivatives/used"
        binaryPath = "/media/Library/ESPYderivatives/files"
        Dir.foreach(importPath) do |sheet|
            if sheet.end_with? ".tsv"
				puts Time.now.to_s + " Reading sheet: " + sheet
			
                filePath = File.join(importPath, sheet)
                headers = CSV.read(filePath, headers: true, encoding: 'windows-1251:utf-8', col_sep: "\t").headers
                #puts headers
                CSV.open(File.join(completePath, sheet), "ab", {col_sep: "\t"}) do |outputFile|
                    outputFile << headers
                end
                
                file = File.open(filePath, "r:ISO-8859-1")
                importData = CSV.parse(file, headers: true, encoding: 'windows-1251:utf-8', col_sep: "\t", skip_blanks: true).reject { |row| row.all?(&:nil?) } 
                
                importData.each do |row|
                
                    item_attributes = {}
                    import_files = []
                    file_list = []
                    
                    file_list = row[2].split('|')
                    #puts file_list
                    file_list.each do |filename|
                        import_files << File.join(binaryPath, filename)
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
                    
                        item_attributes['creator'] = [row[16]]
                        item_attributes['identifier'] = [row[17]]
                        item_attributes['contributor'] = [row[18]]
                        item_attributes['master_format'] = row[19] if row[19].respond_to? :length
                        item_attributes['date_digitized'] = row[20] if row[20].respond_to? :length
                        item_attributes['source'] = [row[21]] if row[21].respond_to? :length
                        item_attributes['extent'] = row[22].split('|') if row[22].respond_to? :length
                        item_attributes['physical_dimensions'] = row[23] if row[23].respond_to? :length
                        
                        #puts item_attributes
                        puts "\tIngesting " + item_attributes['title'][0]
						if row[7].respond_to? :length
							puts "\t\tASpace: " + row[7]
						else
							puts "\t\tIdentifier: " + row[17] if row[17].respond_to? :length
						end
                        
                        work_id = ingest_work("av", item_attributes, depositor)
                        #puts "object created"
						obj = Av.find(work_id)
						
						new_uri = "avs/" + work_id
                        puts "\t\tnow: " + new_uri
                        row[1] = new_uri
                        outputFile << row
                    
                    elsif row[0].downcase == "image"
                    
                        item_attributes['creator'] = [row[16]]
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
                       
                        work_id = ingest_work("image", item_attributes, depositor)
                        #puts "object created"
						obj = Image.find(work_id)
						
						new_uri = "images/" + work_id
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
                       
                        work_id = ingest_work("dao", item_attributes, depositor)
                        #puts "object created"
						obj = Dao.find(work_id)
						
						new_uri = "daos/" + work_id
                        puts "\t\tnow: " + new_uri
                        row[1] = new_uri
                        outputFile << row
                        
                    
                    end
                    outputFile.close
                    
                    attach_files(obj, import_files, depositor)
                    puts "\t\tSuccess!"
                
                end                
                file.close   
                
         
                FileUtils.mv(filePath, finishPath)
            end
        end   

    end

end

