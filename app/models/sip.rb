# Generated via
#  `rails generate hyrax:work Sip`
class Sip < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = SipIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :collection, presence: { message: 'Your SIP must have a collection.' }
  validates :identifier, presence: { message: 'Your SIP must have an identifier.' }

  property :collecting_area, predicate: ::RDF::Vocab::DC.subject, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :collection_number, predicate: ::RDF::Vocab::SKOS.member, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :collection, predicate: ::RDF::Vocab::SCHEMA.collection, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :accession, predicate: ::RDF::Vocab::DC.source do |index|
    index.as :stored_searchable, :facetable
  end

  property :donor_contact, predicate: ::RDF::Vocab::SCHEMA.contactOption do |index|
    index.as :stored_searchable, :facetable
  end

  property :transfer_method, predicate: ::RDF::Vocab::DC.provenance, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :source_location, predicate: ::RDF::Vocab::SCHEMA.location, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :transfer_extent, predicate: ::RDF::Vocab::DC.extent, multiple: false do |index|
    index.as :stored_searchable
  end

  property :transfer_bytes, predicate: ::RDF::Vocab::SCHEMA.contentSize, multiple: false do |index|
    index.as :stored_searchable
  end

  property :date_posix, predicate: ::RDF::Vocab::DC.dateSubmitted, multiple: false do |index|
    index.as :stored_searchable
  end

  property :bagit_profile_identifier, predicate: ::RDF::Vocab::DC.conformsTo, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  def self.multiple?(field)
    if [:title, :identifier, :contributor, :date_created].include? field.to_sym
      false
    else
      super
    end
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
