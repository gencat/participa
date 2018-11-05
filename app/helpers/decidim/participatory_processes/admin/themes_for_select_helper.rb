# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # This class contains helpers needed to format Themes
      # in order to use them in select forms.
      #
      module ThemesForSelectHelper
        # Public: A formatted collection of Themes to be used
        # in forms.
        #
        # Returns an Array.
        def themes_for_select
          @themes_for_select ||= DecidimTheme.all.order(:name).map do |type|
              [translated_attribute(type.name), type.id]            
          end
        end
      end
    end
  end
end