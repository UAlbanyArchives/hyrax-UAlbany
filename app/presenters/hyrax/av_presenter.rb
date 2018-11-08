# Generated via
#  `rails generate hyrax:work Av`
module Hyrax
  class AvPresenter < Hyrax::WorkShowPresenter
  	delegate :processing_activity, :extent, :physical_dimensions, :date_digitized, :accession, :master_format, :archivesspace_record, :collecting_area, :collection_number, :collection, :record_parent, to: :solr_document
  end
end
