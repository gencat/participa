# frozen_string_literal: true

require "decidim/process/extended/engine"
require "decidim/process/extended/notify_admins_on_create"

module Decidim
  module Process
    module Extended
      autoload :ParticipatoryProcessSerializer, "decidim/participatory_processes/participatory_process_serializer"
    end
  end
end
