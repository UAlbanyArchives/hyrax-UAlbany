require 'fileutils'

namespace :rotate do
  desc "TODO"
    
    task logs: :environment do     
        
        logPath = "/media/Library/ESPYderivatives/log"
        currentLog = File.join(logPath, "access.log")
        outPath = File.join(logPath, "old")
        ipFile = File.join(logPath, "localIP.txt")
        
        FileUtils.mv(currentLog, outPath)
        sleep(5)
        logFile = File.join(outPath, "access.log")
        
        ipList = []
        File.open(ipFile, "r") do |f|
            f.each_line do |line|
                ipList << line
            end
        end
        
        analyticsFile = File.join(logPath, "analytics.log")
        
        File.open(logFile, "r") do |f|
            f.each_line do |line|
                unless line.include? "?file=thumbnail"
                    ip = line.split(" ")[0]
                    unless ipList.include? ip
                        timestamp = line.split(" ")[3] + " " + line.split(" ")[4]
                        url = line.split(" ")[6]
                        referer = line.split("\"")[5]
                        collection = ""
                        if url.start_with? "/collections/catalog/"
                            if url.include? "aspace_"
                                collection = url.split("/collections/catalog/")[1].split("aspace_")[0]
                            else
                                if url.include? "?"
                                    collection = url.split("?")[0].split("/collections/catalog/")[1].gsub("-", ".")
                                else
                                    collection = url.split("/collections/catalog/")[1].gsub("-", ".")
                                end
                            end
                        end
                        if url.include? "?"
                            noParams = url.split("?")[0]
                        else
                            noParams = url
                        end
                        if url.start_with? "/downloads/"
                            fsID = noParams.split("/downloads/")[1]
                            collection = FileSet.find(fsID).parent.collection_number
                        end
                        if url.start_with? "/concern/"
                            object = noParams.split("/")[1].chomp("s").titleize
                            objectID = noParams.split("/")[2]
                            collection = ""
                        end
                        File.open(analyticsFile, "a") do |outFile|
                            outFile.write(ip + "|" + timestamp + "|" + url + "|" + referer + "|" + collection + "\n")
                        end
                    end
                end
            end
        end
        
        File.rename(logFile, File.join(outPath, Time.now.getutc.to_s.gsub(":", "-") + ".log"))
  

    end
    
end




