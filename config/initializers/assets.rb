# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w(default_images/image1.png)
Rails.application.config.assets.precompile += %w(default_images/image2.png)
Rails.application.config.assets.precompile += %w(default_images/image3.png)
Rails.application.config.assets.precompile += %w(default_images/image4.png)
Rails.application.config.assets.precompile += %w(default_images/image5.png)

Rails.application.config.assets.precompile += %w(default_images_b/image1.png)
Rails.application.config.assets.precompile += %w(default_images_b/image2.png)
Rails.application.config.assets.precompile += %w(default_images_b/image3.png)
Rails.application.config.assets.precompile += %w(default_images_b/image4.png)
Rails.application.config.assets.precompile += %w(default_images_b/image5.png)

Rails.application.config.assets.precompile += %w(logo_generalitat_gris.png)
Rails.application.config.assets.precompile += %w(logo_generalitat_white.png)
Rails.application.config.assets.precompile += %w(datepicker-locales/foundation-datepicker.oc.js)
Rails.application.config.assets.precompile += %w(favicon.ico)
