require 'csv'

namespace :export do
  desc "exports ids for Espy records"
  
  task espy: :environment do
    total_count = Dao.where("collection_number": "apap301").count
  
    CSV.open("/nhome/gw234478/espyIDs.csv", "wb") do |csv|
        csv << ["dao_id", "fs_ids", "filenames"]
        count = 0
        Dao.where("collection_number": "apap301").each do |dao|
            count += 1
            puts "Exporting " + count.to_s + " of " + total_count.to_s + "..."
            set = []
            set << dao.id
            file_sets = []
            labels = []
            dao.file_sets.each do |fs|
                file_sets << fs.id
                labels << fs.label
            end
            set << file_sets.join("|")
            set << labels.join("|")
            
            csv << set
        end
	end
	
  end

end
