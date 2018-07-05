# Generated via
#  `rails generate hyrax:work Sip`
module Hyrax
  # Generated form for Sip
  class SipForm < Hyrax::Forms::WorkForm
    self.model_class = ::Sip

    

    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs[:identifier] = Array(attrs[:identifier]) if attrs[:identifier]
      attrs[:contributor] = Array(attrs[:contributor]) if attrs[:contributor]
      attrs[:date_created] = Array(attrs[:date_created]) if attrs[:date_created]
      attrs
    end

    def title
      super.first || ""
    end

    def identifier
      super.first || ""
    end

    def contributor
      super.first || ""
    end

    def date_created
      super.first || ""
    end
    
    self.terms -= [:creator, :description, :keyword, :rights_statement, :license, :publisher, :subject, :language, :source, :based_near, :related_url]
    self.terms += [:collecting_area, :collection_number, :collection, :donor_contact, :description, :source_location, :transfer_method, :transfer_extent, :transfer_bytes, :date_posix, :accession, :bagit_profile_identifier]

    self.required_fields -= [:title, :keyword, :rights_statement]
    self.required_fields += [:collecting_area, :title, :identifier, :collection_number, :collection, :accession, :contributor, :source_location, :transfer_method, :transfer_extent, :transfer_bytes, :date_created, :date_posix, :bagit_profile_identifier]
  end
end
