# Generated via
#  `rails generate hyrax:work Av`
module Hyrax
  # Generated controller for Av
  class AvsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Av

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::AvPresenter
  end
end
