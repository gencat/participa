# frozen_string_literal: true

module Decidim
  module Home
    module ContentBlocks
      class FederCell < Decidim::ViewModel
        # include Decidim::CtaButtonHelper
        # include Decidim::SanitizeHelper

        # delegate :current_organization, to: :controller

        # Needed so that the `CtaButtonHelper` can work.
        # def decidim_participatory_processes
        #   Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
        # end

        # def home_participatory_processes
    		# 	@home_participatory_processes ||= ParticipatoryProcess.where(organization: current_organization, show_home: true).published
    		# end
      end
    end
  end
end
