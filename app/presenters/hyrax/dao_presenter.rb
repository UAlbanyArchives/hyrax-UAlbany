# Generated via
#  `rails generate hyrax:work Dao`
module Hyrax
  class DaoPresenter < Hyrax::WorkShowPresenter
  	delegate :archivesspace_record, :collecting_area, :collection_number, :collection, :coverage, :record_parent, :accession, :processing_activity, to: :solr_document
  end
end
