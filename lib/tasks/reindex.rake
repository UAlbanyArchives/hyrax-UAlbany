namespace :reindex do
  desc "reindexes"
  task accession: :environment do
  
	Dao.where("accession": "ua395-DpdVWtrwppUpJur3vAWnBU").each do |dao|
        dao.members.each do |fs|
            puts fs.id
            fs.update_index
        end
    end
    puts "done"	
  end

end

