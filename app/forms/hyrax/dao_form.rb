# Generated via
#  `rails generate hyrax:work Dao`
module Hyrax
  # Generated form for Dao
  class DaoForm < Hyrax::Forms::WorkForm
    self.model_class = ::Dao

    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs
    end

    def title
      super.first || ""
    end
    
    self.terms -= [:creator, :contributor, :publisher, :subject, :license, :identifier, :keyword, :based_near, :related_url, :source, :language, :description, :date_created]
    self.terms += [:record_parent, :collecting_area, :coverage, :date_created, :resource_type, :accession, :archivesspace_record, :collection_number, :collection, :description, :processing_activity, :extent, :language]


    self.required_fields -= [:title, :keyword, :rights_statement]
    self.required_fields += [:collecting_area, :archivesspace_record, :collection_number, :collection, :coverage, :title, :date_created, :resource_type, :rights_statement]

  end
end
