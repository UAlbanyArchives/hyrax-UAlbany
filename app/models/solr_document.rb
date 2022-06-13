# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  def archivesspace_record
    self['archivesspace_record_tesim']
  end

  def collecting_area
    self['collecting_area_tesim']
  end

  def collection_number
    self['collection_number_tesim']
  end

  def collection
    self['collection_tesim']
  end

  def coverage
    self['coverage_tesim']
  end

  def record_parent
    self['record_parent_tesim']
  end

  def accession
    self['accession_tesim']
  end

  def processing_activity
    self['processing_activity_tesim']
  end

  def extent
    self['extent_tesim']
  end

  def physical_dimensions
    self['physical_dimensions_tesim']
  end

  def date_digitized
    self['date_digitized_tesim']
  end

  def master_format
    self['master_format_tesim']
  end

  def donor_contact
    self['donor_contact_tesim']
  end

  def source_location
    self['source_location_tesim']
  end

  def transfer_method
    self['transfer_method_tesim']
  end

  def transfer_extent
    self['transfer_extent_tesim']
  end

  def date_posix
    self['date_posix_tesim']
  end

  def bagit_profile_identifier
    self['bagit_profile_identifier_tesim']
  end


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models. 

  use_extension( Hydra::ContentNegotiation )
end
