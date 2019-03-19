require 'csv'
require 'fileutils'

namespace :add do
  desc "TODO"
      
    task accessions: :environment do
    
        importPath = "/media/Library/ESPYderivatives/processNewUploads"
        filePath = File.join(importPath, "newHyraxAccessions.tsv")
        completePath = File.join(importPath, "complete", Time.now.getutc.to_s.gsub(":","-") + "newHyraxAccessions.tsv")
        
        if File.file?(filePath)
        
            file = File.open(filePath, "r:ISO-8859-1")
            accessionData = CSV.parse(file, headers: true, col_sep: "\t", skip_blanks: true)
            
            accessionData.each do |row|
                id = row[1]
                accession = row[2]
                obj = Dao.find(id)
                
                unless obj.accession.include? accession
                    obj.accession = [accession]
                    obj.save
                end
            end
                
            
            FileUtils.mv(filePath, completePath)
        end
    end
    
end



