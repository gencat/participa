# frozen_string_literal: true

module Decidim::Admin::StaticPagesControllerDecorator
  def self.decorate
    Decidim::Admin::StaticPagesController.class_eval do
      helper_method :page

      def new
        enforce_permission_to :create, :static_page
        @form = form(Decidim::Admin::StaticPageForm).from_params(
          attachment: form(Decidim::Admin::AttachmentForm).from_params({})
        )
      end

      def create
        enforce_permission_to :create, :static_page
        @form = form(Decidim::Admin::StaticPageForm).from_params(form_params)

        Decidim::Admin::CreateStaticPage.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("static_pages.create.success", scope: "decidim.admin")
            redirect_to static_pages_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("static_pages.create.error", scope: "decidim.admin")
            render :new
          end
        end
      end

      def update
        @page = collection.find(params[:id])
        enforce_permission_to :update, :static_page, static_page: page
        @form = form(StaticPageForm).from_params(form_params)

        UpdateStaticPage.call(page, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("static_pages.update.success", scope: "decidim.admin")
            redirect_to static_pages_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("static_pages.update.error", scope: "decidim.admin")
            render :edit
          end
        end
      end

      def edit
        enforce_permission_to :update, :static_page, static_page: page
        @form = form(Decidim::Admin::StaticPageForm).from_model(page)
      end

    end
  end
end

::Decidim::Admin::StaticPagesControllerDecorator.decorate
