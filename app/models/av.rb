# Generated via
#  `rails generate hyrax:work Av`
class Av < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = AvIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'AV materials must have a title.' }
  validates :collecting_area, presence: { message: 'AV materials must belong to a collecting area.' }
  validates :collection, presence: { message: 'AV materials must belong to a collection.' }
  validates :collection_number, presence: { message: 'AV materials must have a collection number.' }
  validates :description, presence: { message: 'AV materials must have a description.' }
  validates :creator, presence: { message: 'AV materials must have a creator.' }
  validates :contributor, presence: { message: 'AV materials must have a technician, or the person who digitided the item.' }
  validates :resource_type, presence: { message: 'AV materials must have a resource type.' }
  validates :license, presence: { message: 'AV material must have a license.' }


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

  property :accession, predicate: ::RDF::Vocab::SCHEMA.identifier do |index|
    index.as :stored_searchable, :facetable
  end

  property :master_format, predicate: ::RDF::Vocab::SCHEMA.encodingFormat, multiple: false do |index|
    index.as :stored_searchable
  end

  property :processing_activity, predicate: ::RDF::Vocab::PROV.activity do |index|
    index.as :stored_searchable
  end

  property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
    index.as :stored_searchable
  end 

  property :physical_dimensions, predicate: ::RDF::Vocab::DC.spatial, multiple: false do |index|
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
