# frozen_string_literal: true

require_dependency "decidim/admin/application_controller"
# require_dependency "../models/decidim/department/abilities/admin_user"
require_dependency "../commands/decidim/admin/update_theme"
require_dependency "../commands/decidim/admin/create_theme"

module Decidim
  module Admin
    # Controller that allows managing all departments at the admin panel.
    #
    class ThemesController < Decidim::Admin::ApplicationController
      layout "decidim/admin/extended/settings"

      def index
        # authorize! :index, Theme
        @themes = collection
      end

      def collection
        @themes ||= DecidimTheme.all.order(:name)
      end

      def edit
        # authorize! :update, Theme
        @form = form(ThemeForm).from_model(department)
      end

      def update
        @themes = collection.find(params[:id])
        # authorize! :update, Theme
        @form = form(ThemeForm).from_params(params)

        UpdateTheme.call(department, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("themes.update.success", scope: "decidim.admin")
            redirect_to "/admin/themes"
          end
          on(:exists) do
            flash.now[:alert] = I18n.t("themes.create.exists", scope: "decidim.admin")
            render :edit
          end
          on(:invalid) do
            flash.now[:alert] = I18n.t("themes.update.error", scope: "decidim.admin")
            render :edit
          end
        end
      end

      def new
        # authorize! :new, Theme
        @form = form(ThemeForm).instance
      end

      def create
        # authorize! :new, Theme
        @form = form(ThemeForm).from_params(params)

        CreateTheme.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("themes.create.success", scope: "decidim.admin")
            redirect_to "/admin/themes"
          end
          on(:exists) do
            flash.now[:alert] = I18n.t("themes.create.exists", scope: "decidim.admin")
            render :new
          end
          on(:invalid) do
            flash.now[:alert] = I18n.t("themes.create.error", scope: "decidim.admin")
            render :new
          end
        end
      end

      def destroy
        # authorize! :destroy, Theme
        department.destroy!

        flash[:notice] = I18n.t("themes.destroy.success", scope: "decidim.admin")

        redirect_to "/admin/themes/"
      end

      def department
        @themes ||= DecidimTheme.find(params[:id])
      end
    end
  end
end
