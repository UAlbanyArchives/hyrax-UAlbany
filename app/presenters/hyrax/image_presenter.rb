# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
  	delegate :date_digitized, :accession, :master_format, :archivesspace_record, :collecting_area, :collection_number, :collection, :record_parent, to: :solr_document
  end
end
