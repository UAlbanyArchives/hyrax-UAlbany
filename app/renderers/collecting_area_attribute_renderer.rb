# app/renderers/collecting_area_attribute_renderer.rb
class CollectingAreaAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def attribute_value_to_html(value)
  	if value == "New York State Modern Political Archive"
		@code = "apap"
  	elsif value == "National Death Penalty Archive"
		@code = "ndpa"
  	elsif value == "German and Jewish Intellectual Émigré Collections"
  		@code = "ger"
  	elsif value == "Business, Literary, and Local History Manuscripts"
  		@code = "mss"
  	elsif value == "University Archives"
  		@code = "ua"
  	end
    %(This collection is part of the <a href="#{URI.join( Hyrax::Application.config.arclight_url, "/description/repositories/", @code).to_s }">#{value}</a>)
  end
end
