# Generated via
#  `rails generate hyrax:work Image`
class Image < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = ImageIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  #validates :archivesspace_record, presence: { message: 'DAOs must link to ArchivesSpace.' }
  #validates_length_of :archivesspace_record, :minimum => 32, :maximum => 32, :allow_blank => false


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
