# Generated via
#  `rails generate hyrax:work Dao`
class Dao < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = DaoIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :archivesspace_record, presence: { message: 'DAOs must link to archival object in ArchivesSpace.' }
  validates_length_of :archivesspace_record, :minimum => 32, :maximum => 32, :allow_blank => false

  validates :collecting_area, presence: { message: 'DAOs must belong to a collecting area.' }
  validates :collection, presence: { message: 'DAOs must belong to a collection.' }
  validates :collection_number, presence: { message: 'DAOs must have a collection number.' }
  validates :coverage, presence: { message: 'DAOs must be considered the whole or only part of the linked archival object.' }
  validates :date_created, presence: { message: 'DAOs must have a creation date.' }
  validates :resource_type, presence: { message: 'DAOs must have a resource type.' }
  validates :license, presence: { message: 'DAOs must have a license.' }


  property :archivesspace_record, predicate: ::RDF::Vocab::DC.relation, multiple: false do |index|
    index.as :stored_searchable
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

  property :coverage, predicate: ::RDF::Vocab::DC.coverage, multiple: false do |index|
    index.as :stored_searchable
  end

  property :accession, predicate: ::RDF::Vocab::SCHEMA.identifier do |index|
    index.as :stored_searchable, :facetable
  end

  property :processing_activity, predicate: ::RDF::Vocab::PROV.activity do |index|
    index.as :stored_searchable
  end

  property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
    index.as :stored_searchable
  end

  def self.multiple?(field)
    if [:title].include? field.to_sym
      false
    else
      super
    end
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
