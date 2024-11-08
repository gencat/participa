# frozen_string_literal

module Decidim
  class ExternalAuthorPresenter < SimpleDelegator
    include ActionView::Helpers::UrlHelper

    def name
      __getobj__.name
    end

    def avatar
      attached_uploader(:avatar)
    end

    def avatar_url
      avatar.default_url
    end
  end
end
