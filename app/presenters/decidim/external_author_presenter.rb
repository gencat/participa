# frozen_string_literal

module Decidim
  class ExternalAuthorPresenter < SimpleDelegator
    include ActionView::Helpers::UrlHelper

    def name
      __getobj__.name
    end

    def avatar_url(_something)
      ActionController::Base.helpers.asset_pack_path("media/images/default-avatar.svg")
    end

    def method_missing(method, *args)
      if method.to_s.ends_with?("?")
        false
      elsif [:profile_path, :badge, :followers_count, :cache_key_with_version].include?(method)
        ""
      else
        super
      end
    end
  end
end
