# frozen_string_literal: true

module Decidim
  module Admin
    # Controller that allows managing all themes at the admin panel.
    #
    class ThemesController < Decidim::Admin::ApplicationController
      include Decidim::Admin::Concerns::Administrable
      layout "decidim/admin/extended/settings"

      def index
        enforce_permission_to :read, :theme
        @themes = collection
      end

      def collection
        @themes ||= DecidimTheme.all.order(:name)
      end

      def new
        enforce_permission_to :create, :theme
        @form = form(ThemeForm).instance
      end

      def create
        enforce_permission_to :create, :theme
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

      def edit
        enforce_permission_to :update, :theme, theme: theme
        @form = form(ThemeForm).from_model(theme)
      end

      def update
        @themes = collection.find(params[:id])
        enforce_permission_to :update, :theme, theme: theme
        @form = form(ThemeForm).from_params(params)

        UpdateTheme.call(theme, @form) do
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

      def destroy
<<<<<<< HEAD
        enforce_permission_to :destroy, :theme, theme: theme
        theme.destroy!
=======
        # authorize! :destroy, Theme
        department.destroy!
>>>>>>> initial commit on upgrade to 0.12

        flash[:notice] = I18n.t("themes.destroy.success", scope: "decidim.admin")

        redirect_to "/admin/themes/"
      end

      def theme
        @themes ||= DecidimTheme.find(params[:id])
      end
    end
  end
end
