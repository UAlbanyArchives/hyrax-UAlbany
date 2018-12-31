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

end
