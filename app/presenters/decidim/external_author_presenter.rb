# frozen_string_literal: true

module Decidim
  class ExternalAuthorPresenter < SimpleDelegator
    include ActionView::Helpers::UrlHelper

    delegate :name, to: :__getobj__

    def avatar_url(_something)
      ActionController::Base.helpers.asset_pack_path("media/images/default-avatar.svg")
    end

    def respond_to_missing?(*)
      true
    end

    def method_missing(method, *args)
      if method.to_s.ends_with?("?")
        false
      elsif [:profile_path, :badge, :followers, :followers_count, :cache_key_with_version].include?(method)
        ""
      else
        super
      end
    end
  end
end
