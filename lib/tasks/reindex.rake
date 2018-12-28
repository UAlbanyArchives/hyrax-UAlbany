namespace :reindex do
  desc "updates the index by collectionID"
  task :collection, [:id] do |task, args|
	count = 0
    Dao.where("collection_number": args.id).each do |dao|
	
		fs = dao.members[0]
		fs.update_index
		
		count += 1
		puts count
	
	end
	
  end

end
