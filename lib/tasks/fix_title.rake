namespace :fix do
  desc "updates the index by collectionID"
  task title: :environment do
	count = 0
	Dao.where("collection_number": "apap015").each do |dao|
		count += 1
		if count > 2240
			title = dao.title[0].strip()
			dao.title = [title]
			dao.save
			
			puts count
		end
	end
	
  end
  
  desc "adds subseries to ua395"
  task ua395: :environment do
	count = 0
	Dao.where("collection_number": "ua395").each do |dao|
        count += 1
		unless dao.record_parent.include?("c7f68e567f66c8f95cafdd00e28d1869")
            puts count
            parents = ["c7f68e567f66c8f95cafdd00e28d1869"]
            parents << dao.record_parent[0]
            parents << dao.record_parent[1]
            dao.record_parent = parents
            dao.save
            puts "Saved " + dao.id.to_s
        end
	end
	
  end

end
