# frozen_string_literal: true

module Decidim::Pages::Admin::PagesControllerDecorator
  def self.decorate
    Decidim::Pages::Admin::PagesController.class_eval do
      # helper_method :page

      def edit
        enforce_permission_to(:update, :page)
        @form = form(::Decidim::Pages::Admin::PageForm).from_model(page)
      end
      
      # def update
      #   enforce_permission_to :update, :page
      # 
      #   @form = form(Admin::PageForm).from_params(params)
      # 
      #   Admin::UpdatePage.call(@form, page) do
      #     on(:ok) do
      #       flash[:notice] = I18n.t("pages.update.success", scope: "decidim.pages.admin")
      #       redirect_to parent_path
      #     end
      # 
      #     on(:invalid) do
      #       flash.now[:alert] = I18n.t("pages.update.invalid", scope: "decidim.pages.admin")
      #       render action: "edit"
      #     end
      #   end
      # end


      private
      # def page
      #   @page ||= ::Decidim::Pages::Page.find_by(component: current_component)
      # end

      # def collection
      #   @collection ||= Page.where(component: current_component).not_hidden.published
      # end
      # 
      # def page
      #   @page ||= collection.find(params[:id])
      # end

    end
  end
end

::Decidim::Pages::Admin::PagesControllerDecorator.decorate
