module Decidim
  module Process
    module Extended
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Process::Extended
        # make decorators autoload in development env
        config.autoload_paths << File.join(
          Decidim::Process::Extended::Engine.root, 'app', 'decorators', '{**}'
        )

        # make decorators available to applications that use this Engine
        config.to_prepare do
          Dir.glob(Decidim::Process::Extended::Engine.root + 'app/decorators/**/*_decorator*.rb').each do |c|
            require_dependency(c)
          end
        end
      end
    end
  end
end
