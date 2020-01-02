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

  desc "fix unicode issues in ua435"
  task ua435: :environment do
	require 'net/http'
    
    obj = Dao.find("rr172g10t")
    ref_id = obj.archivesspace_record
    url = "https://archives.albany.edu/description/catalog/ua435aspace_" + ref_id
    
    req = Net::HTTP::Get.new(url)
    res = Net::HTTP.start(url) {|http|
      http.request(req)
    }
    puts res.body
    
	
  end

end
