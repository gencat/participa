# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # This class contains helpers needed to format Themes
      # in order to use them in select forms.
      #
      module DepartmentsForSelectHelper
        # Public: A formatted collection of Themes to be used
        # in forms.
        #
        # Returns an Array.
        def departments_for_select
          @departments_for_select ||= ::DecidimDepartment.all.order(:name).map do |department|
              [department.name, department.id]
          end
        end
      end
    end
  end
end