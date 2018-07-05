# Generated via
#  `rails generate hyrax:work Dao`
module Hyrax
  # Generated controller for Dao
  class DaosController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Dao

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DaoPresenter
  end
end
