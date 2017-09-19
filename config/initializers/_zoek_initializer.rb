require 'zoek'
module Zoek
  zoek_service = Zoek::Index.new(db: Rails.root+'./data.json')
  INDEX = zoek_service.index
  DOCUMENTS = zoek_service.documents
end
