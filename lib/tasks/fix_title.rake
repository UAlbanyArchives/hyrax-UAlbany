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
  
  desc "changes apap301 to ndpa"
  task apap301: :environment do
	count = 0
	Dao.where("collection_number": "apap301").where("collecting_area": "New York State Modern Political Archive").each do |record|
        count += 1
        puts count
        unless record.collecting_area == "National Death Penalty Archive"
        	record.collecting_area = "National Death Penalty Archive"
        	record.save
        	puts "Saved " + record.id.to_s
		end
	end
	
  end

  desc "fix unicode issues in ua435"
  task ua435: :environment do
    require 'openssl'
    
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    
    count = 0
    Dao.where("accession": "ua435_nDmescjNLkkjigbozTXSTY").each do |obj|
        ref_id = obj.archivesspace_record
        url = "https://archives.albany.edu" + "/description/catalog/ua435aspace_" + ref_id + "?format=json"
        count = count + 1
        
        uri = URI(url)
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        title = data["response"]["document"]["title_ssm"][0]
        
        obj.title = []
        obj.title << title
        obj.save
        
        puts count.to_s + ": " + obj.id.to_s
    end
	
  end

end
