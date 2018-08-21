# hyrax-UAlbany
UAlbany's Hyrax instance

## License
*[Hyrax license](https://github.com/samvera/hyrax/blob/master/LICENSE)
*All UAlbany modifications are in the public domain


## How UAlbany's Hyrax is different than stock Hyrax 2.1

### UAlbany styling assets
* app/assets/javascripts/headerAffix.js
* app/assets/javascripts/arclightFindRecord.js (Load Record button in forms)
* app/assets/javascripts/getArclightData.js  (get display data during page load)
* app/assets/stylesheets/browseNav.css
* app/assets/stylesheets/headerNavbar.css
* app/assets/stylesheets/customStyling.css
* app/assets/stylesheets/application.css (added the above and widened content_wrapper)

### Some local variables set here
* config/application.rb

### UAlbany styling templates
* app/views/layouts/hyrax.html.erb (override library)
* app/views/_custom_util_links.html.erb (override library)
* app/views/_ua_masthead.html.erb
* app/views/shared (new directory)
* app/views/shared/_locale_picker.html.erb (override library)
* app/views/shared/_footer.html.erb (override library)
* app/views/catalog (new directory)
* app/views/catalog/_search_form.html.erb

### Images
* /public/hyrax_logo.png
* /public/favicon.ico

### Derivative changes
* app/services (new directory)
* app/services/hyrax (new directory)
* app/services/hyrax/file_set_derivatives_service.rb (override library)

### Controlled Vocabularies
config/authorities/collecting_areas.yml
config/authorities/coverage.yml
* app/services/collecting_areas_service.rb
* app/services/coverage.rb

### Works
* rails generate hyrax:work Dao
* rails generate hyrax:work Sip
* rails generate hyrax:work Image
* rails generate hyrax:work Av

### edited models
* app/models/dao.rb
* app/models/sip.rb
* app/models/image.rb
* app/models/av.rb

### edited forms
* app/forms/hyrax/dao_form.rb
* app/forms/hyrax/sip_form.rb
* app/forms/hyrax/image_form.rb
* app/forms/hyrax/av_form.rb

### Add sidekiq and pdfjs to routes
* /config/routes.rb

### Turn on iiif
* config/initializers/hyrax.rb (set config.iiif_image_server to true)

### Edited form fields
* app/views/records/edit_fields/_collecting_area.html.erb
* app/views/daos/edit_fields/_coverage.html.erb

### Load Records button
* app/views/daos/edit_fields (new directory)
* app/views/daos/edit_fields/_collection_number.html.erb
* app/views/images/edit_fields (new directory)
* app/views/images/edit_fields/_collection_number.html.erb
* app/views/avs/edit_fields (new directory)
* app/views/avs/edit_fields/_collection_number.html.erb
* app/views/sips/edit_fields (new directory)
* app/views/sips/edit_fields/_collection_number.html.erb

### Locales
* config/locales/dao.en.yml
* config/locales/sip.en.yml
* config/locales/image.en.yml
* config/locales/av.en.yml
* config/locales/hyrax.en.yml
	* Override "search"
	* Override "file_set"
	* Override "simple_form"

### Delegate new fields in presenters so views have access to display them
* app/presenters/hyrax/dao_presenter.rb
* app/presenters/hyrax/sip_presenter.rb
* app/presenters/hyrax/image_presenter.rb
* app/models/solr_document.rb

### Show top Breadcrumbs
* app/views/hyrax/base/_work_type.html.erb

### Search Results display
* app/views/catalog/_index_list_default.html.erb (just made results wider for long descriptions, line 1)


### Display Documents
* app/views/hyrax/base/show.html.erb
* app/views/hyrax/file_sets/show.html.erb (minor changes to file_set pdf display line 3)
	* The JS on lines 5-20 takes the search param used in "Back to Search Results" and has pdf.js search it on load
* app/views/hyrax/base/_show_actions.html.erb (removed attach and feature panel buttons)
* app/views/hyrax/base/_work_title.erb (made title wider if no edit/delete buttons)
* app/views/hyrax/base/_items.html.erb (file_set items in bottom, fix responsiveness)
* app/views/hyrax/base/_member.html.erb (remove visiblity for non-editors)
* app/views/hyrax/base/_form_visibility_component.html.erb (no Sherpa/Romeo pop-up)
* app/presenters/hyrax/work_show_presenter.rb (Get all that junk out of page titles on line 31)


### How content is displayed
* app/views/hyrax/base/_representative_media.html.erb
* app/views/hyrax/file_sets/media_display/_pdf.html.erb
* app/views/hyrax/file_sets/media_display/_office_document.html.erb
* app/views/hyrax/file_sets/media_display/_audio.html.erb
* app/views/hyrax/file_sets/media_display/_video.html.erb (had to add file param on lines 5 & 6 to get the viewer to work)
Also changes link-to in these to buttons, and added ones to download (labels are in locales)

### these to just add bootstrap grid classes so they are inline
* app/views/hyrax/base/_citations.html.erb
* app/views/hyrax/base/_social_media.html.erb


### Display Fields
* app/views/hyrax/base/_attribute_rows.html.erb (defines the renderers for metadata fields)
* app/views/hyrax/base/_item_context.html.erb
	* This is a new file that shows metadata files that are about the item's context rather then describe the item
* app/views/hyrax/base/_work_coverage.html.erb (custom renders coverage much like description)

### Renderers define how individual metadata fields are displayed
* app/renderers/collecting_area_attribute.rb
* app/renderers/linear_attribute_renderer.rb
* app/renderers/linear_faceted_attribute_renderer.rb
* app/renderers/hyrax/renderers/rights_statement_attribute_renderer.rb (edited)


### Changed what fields can be faceted (add_facet_field section)
* app/controllers/catalog_controller.rb

### Changed what fields are shown in search results (add_index_field section)
* app/controllers/catalog_controller.rb

### Changed what fields searchable (add_show_field section)
* app/controllers/catalog_controller.rb

### Allowed larger file uploads
* in rvm gem, changed maxFileSize
	* /usr/local/rvm/[rubyversion]@[gemset]/gems/hyrax-2.1.0/vendor/assets/javascripts/fileupload/jquery.fileupload-validate.js

### Limit delete rights (http://samvera.github.io/access-controls.html)
* app/models/ability.rb

### Allow pdfs to be embeded??
* app/controllers/hyrax/downloads_controller.rb (line 30)
* app/controllers/hyrax/single_use_links_viewer_controller.rb
* override content_disposition?

### Citation formats (added collection)
* app/helpers/hyrax/citations_behaviors/formatters/open_url_formatter.rb
* app/models/concerns/hyrax/solr_document/export.rb

### custom Schema.org config
* config/schema_org.yml
* app/presenters/hyrax/presents_attributes.rb # lines 72-77
* app/views/hyrax/base/_work_description.erb (added itemprop for description)

### About tmp
* config/initializers/hyrax.rb (tmp settings)
	* the Id minter state and derivatives have been moved so you can clean out hyrax/tmp
* should regularly clean out hyrax/tmp and /tmp in production, if files are uploaded but not saved or deleted, they stay here


#### Fixed Bug in Hydra-Derivatives library (https://github.com/samvera/hydra-derivatives/pull/185)

