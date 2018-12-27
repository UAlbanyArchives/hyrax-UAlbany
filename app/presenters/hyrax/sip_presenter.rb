# Generated via
#  `rails generate hyrax:work Sip`
module Hyrax
  class SipPresenter < Hyrax::WorkShowPresenter
  	delegate :collecting_area, :collection_number, :collection, :accession, :donor_contact, :transfer_method, :source_location, :transfer_extent, :transfer_bytes, :date_posix, :bagit_profile_identifier, to: :solr_document
  end
end
