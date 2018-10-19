# Generated via
#  `rails generate hyrax:work Image`
class Image < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = ImageIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Images must have a title.' }
  validates :collecting_area, presence: { message: 'Images must belong to a collecting area.' }
  validates :collection, presence: { message: 'Images must belong to a collection.' }
  validates :collection_number, presence: { message: 'Images must have a collection number.' }
  validates :description, presence: { message: 'Images must have a description.' }
  validates :subject, presence: { message: 'Images must have at least one subject.' }
  validates :creator, presence: { message: 'Images must have a creator.' }
  validates :contributor, presence: { message: 'Images must have a technician, or the person who digitided the item.' }
  validates :resource_type, presence: { message: 'Images must have a resource type.' }
  validates :rights_statement, presence: { message: 'Images must have a rights statement.' }


  property :archivesspace_record, predicate: ::RDF::Vocab::DC.relation, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :collecting_area, predicate: ::RDF::Vocab::SKOS.hasTopConcept, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :collection_number, predicate: ::RDF::Vocab::SKOS.member, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :collection, predicate: ::RDF::Vocab::SCHEMA.collection, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :record_parent, predicate: ::RDF::Vocab::SKOS.broader do |index|
    index.as :stored_searchable, :facetable
  end

  property :date_digitized, predicate: ::RDF::Vocab::DC.available, multiple: false do |index|
    index.as :stored_searchable
  end

  property :master_format, predicate: ::RDF::Vocab::SCHEMA.encodingFormat, multiple: false do |index|
    index.as :stored_searchable
  end

  def self.multiple?(field)
    if [:title, :description, :contributor].include? field.to_sym
      false
    else
      super
    end
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
