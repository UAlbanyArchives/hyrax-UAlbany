# app/renderers/collecting_area_attribute_renderer.rb
class CollectingAreaAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def attribute_value_to_html(value)
  	if value == "New York State Modern Political Archive"
  		abbr = "apap"
  	elsif value == "National Death Penalty Archive"
  		abbr = "ndpa"
  	elsif value == "German and Jewish Intellectual Émigré Collections"
  		abbr = "ger"
  	elsif value == "Business, Literary, and Local History Manuscripts"
  		abbr = "mss"
  	elsif value == "University Archives"
  		abbr = "ua"
  	end
  	repo_url = Hyrax::Application.config.arclight_url + "/repositories/" + abbr
    %(This collection is part of the <a href="#{repo_url}">#{value}</a>)
  end
end