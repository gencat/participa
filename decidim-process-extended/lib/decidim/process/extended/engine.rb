module Decidim
  module Process
    module Extended
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Process::Extended
      end
    end
  end
end
