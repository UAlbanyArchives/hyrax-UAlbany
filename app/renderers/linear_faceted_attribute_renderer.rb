# app/renderers/linear_faceted_attribute_renderer.rb
class LinearFacetedAttributeRenderer < Hyrax::Renderers::AttributeRenderer

  def label
        "<div class='col-md-6 linearField'>" + 
        translate(
          :"blacklight.search.fields.#{work_type_label_key}.show.#{field}",
          default: [:"blacklight.search.fields.show.#{field}",
                    :"blacklight.search.fields.#{field}",
                     options.fetch(:label, field.to_s.humanize)]
        ) + "</div>"

  end

  def search_path(value)
    Rails.application.routes.url_helpers.search_catalog_path(:"f[#{search_field}][]" => value, locale: I18n.locale)
  end

  def search_field
    ERB::Util.h(ActiveFedora.index_field_mapper.solr_name(options.fetch(:search_field, field), :facetable, type: :string))
  end

  def li_value(value)
    link_to(ERB::Util.h(value), search_path(value))
  end

  def work_type_label_key
    options[:work_type] ? options[:work_type].underscore : nil
  end

end
