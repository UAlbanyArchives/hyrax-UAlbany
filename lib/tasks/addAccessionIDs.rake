require 'csv'
require 'fileutils'

namespace :add do
  desc "TODO"
      
    task accessions: :environment do
    
        puts Time.now.getutc.to_s
        
        importPath = "/media/Library/ESPYderivatives/processNewUploads"
        filePath = File.join(importPath, "newHyraxAccessions.tsv")
        completePath = File.join(importPath, "complete", Time.now.getutc.to_s.gsub(":","-") + "_newHyraxAccessions.tsv")
        
        if File.file?(filePath)
        
            file = File.open(filePath, "r:ISO-8859-1")
            accessionData = CSV.parse(file, headers: false, col_sep: "\t", skip_blanks: true)
            
            accessionData.each do |row|
                url = row[0]
		#id = row[1]
		# row[1] id isn't safe because of leading 0s
		id = url.partition('/').last
                accession = row[2]
		if Dao.exists?(id)
                    obj = Dao.find(id)
                
                    unless obj.accession.include? accession
                        obj.accession = [accession]
                        obj.save
		        puts "\t added accession " + accession + " --> " + row[0]
                    end
                else
                    puts "\t" + id + " not found. May have been deleted."
                end
            end
                
            
            FileUtils.mv(filePath, completePath)
        end
    end
    
end



