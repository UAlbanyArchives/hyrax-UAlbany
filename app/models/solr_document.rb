# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  def archivesspace_record
    self[ActiveFedora.index_field_mapper.solr_name('archivesspace_record')]
  end

  def collecting_area
    self[ActiveFedora.index_field_mapper.solr_name('collecting_area')]
  end

  def collection_number
    self[ActiveFedora.index_field_mapper.solr_name('collection_number')]
  end

  def collection
    self[ActiveFedora.index_field_mapper.solr_name('collection')]
  end

  def coverage
    self[ActiveFedora.index_field_mapper.solr_name('coverage')]
  end

  def record_parent
    self[ActiveFedora.index_field_mapper.solr_name('record_parent')]
  end

  def accession
    self[ActiveFedora.index_field_mapper.solr_name('accession')]
  end

  def processing_activity
    self[ActiveFedora.index_field_mapper.solr_name('processing_activity')]
  end

  def extent
    self[ActiveFedora.index_field_mapper.solr_name('extent')]
  end

  def physical_dimensions
    self[ActiveFedora.index_field_mapper.solr_name('physical_dimensions')]
  end

  def date_digitized
    self[ActiveFedora.index_field_mapper.solr_name('date_digitized')]
  end

  def master_format
    self[ActiveFedora.index_field_mapper.solr_name('master_format')]
  end

  def donor_contact
    self[ActiveFedora.index_field_mapper.solr_name('donor_contact')]
  end

  def source_location
    self[ActiveFedora.index_field_mapper.solr_name('source_location')]
  end

  def transfer_method
    self[ActiveFedora.index_field_mapper.solr_name('transfer_method')]
  end

  def transfer_extent
    self[ActiveFedora.index_field_mapper.solr_name('transfer_extent')]
  end

  def date_posix
    self[ActiveFedora.index_field_mapper.solr_name('date_posix')]
  end

  def bagit_profile_identifier
    self[ActiveFedora.index_field_mapper.solr_name('bagit_profile_identifier')]
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
