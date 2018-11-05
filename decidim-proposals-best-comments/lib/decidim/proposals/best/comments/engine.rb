module Decidim
  module Proposals
    module Best
      module Comments
        class Engine < ::Rails::Engine
          isolate_namespace Decidim::Proposals::Best::Comments
        end
      end
    end
  end
end
