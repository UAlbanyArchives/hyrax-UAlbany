# app/renderers/collecting_area_attribute_renderer.rb
class CollectingAreaAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def attribute_value_to_html(value)
  	if value == "New York State Modern Political Archive"
  		repo_url = "https://archives.albany.edu/browse/apap.html"
  	elsif value == "National Death Penalty Archive"
  		repo_url = "https://archives.albany.edu/browse/91.html"
  	elsif value == "German and Jewish Intellectual Émigré Collections"
  		repo_url = "https://archives.albany.edu/browse/ger.html"
  	elsif value == "Business, Literary, and Local History Manuscripts"
  		repo_url = "https://archives.albany.edu/browse/mss.html"
  	elsif value == "University Archives"
  		repo_url = "https://archives.albany.edu/web/ua"
  	end
    %(This collection is part of the <a href="#{repo_url}">#{value}</a>)
  end
end