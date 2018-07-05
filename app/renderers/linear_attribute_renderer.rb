# app/renderers/linear_attribute_renderer.rb
class LinearAttributeRenderer < Hyrax::Renderers::AttributeRenderer

  def label
        "<div class='col-md-6 linearField'>" + 
        translate(
          :"blacklight.search.fields.#{work_type_label_key}.show.#{field}",
          default: [:"blacklight.search.fields.show.#{field}",
                    :"blacklight.search.fields.#{field}",
                    options.fetch(:label, field.to_s.humanize) ]
        ) + "</div>"

  end


  def work_type_label_key
    options[:work_type] ? options[:work_type].underscore : nil
  end

end