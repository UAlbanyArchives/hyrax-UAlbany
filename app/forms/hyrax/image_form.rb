# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  # Generated form for Image
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image

    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs[:description] = Array(attrs[:description]) if attrs[:description]
      attrs[:contributor] = Array(attrs[:contributor]) if attrs[:contributor]
      attrs
    end

    def title
      super.first || ""
    end

    def description
      super.first || ""
    end

    def contributor
      super.first || ""
    end

    self.terms -= [:keyword, :creator, :contributor, :publisher, :language, :based_near, :related_url, :source, :identifier]
    self.terms += [:collecting_area, :collection_number, :collection, :contributor, :creator, :resource_type, :date_digitized, :master_format, :identifier, :archivesspace_record, :record_parent]

    self.required_fields -= [:keyword, :title, :creator, :rights_statement]
    self.required_fields += [:collecting_area, :title, :collection_number, :collection, :description, :resource_type, :subject, :creator, :contributor, :license]


  end
end
