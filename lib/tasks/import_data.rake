namespace :data do
  desc "Import the data"
  task import: :environment do
    puts "Importing"
    data = JSON.parse(File.read('./data.json'))

    data.each do |obj|
      language = Language.create do |l|
        l.name = obj["Name"]
        l.lang_type = obj["Type"]
        l.designed_by = obj["Designed by"]
      end
    end

  end
end
