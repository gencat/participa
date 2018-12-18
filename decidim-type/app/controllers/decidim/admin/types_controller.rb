# frozen_string_literal: true

module Decidim
  module Admin
    # Controller that allows managing all types at the admin panel.
    #
    class TypesController < Decidim::Admin::ApplicationController
      include Decidim::Admin::Concerns::Administrable
      layout "decidim/admin/extended/settings"

      def index
        enforce_permission_to :read, :type
        @types = collection
      end

      def collection
        @collection ||= ::DecidimType.all.order(:name)
      end

      def new
        enforce_permission_to :create, :type
        @form = form(TypeForm).instance
      end

      def create
        enforce_permission_to :create, :type
        @form = form(TypeForm).from_params(params)

        CreateType.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("types.create.success", scope: "decidim.admin")
            redirect_to "/admin/types"
          end
          on(:exists) do
            flash.now[:alert] = I18n.t("types.create.exists", scope: "decidim.admin")
            render :new
          end
          on(:invalid) do
            flash.now[:alert] = I18n.t("types.create.error", scope: "decidim.admin")
            render :new
          end
        end
      end

      def edit
        enforce_permission_to :update, :type, type: type
        @form = form(TypeForm).from_model(type)
      end

      def update
        @types = collection.find(params[:id])
        enforce_permission_to :update, :type, type: type
        @form = form(TypeForm).from_params(params)

        UpdateType.call(type, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("types.update.success", scope: "decidim.admin")
            redirect_to "/admin/types"
          end
          on(:exists) do
            flash.now[:alert] = I18n.t("types.create.exists", scope: "decidim.admin")
            render :edit
          end
          on(:invalid) do
            flash.now[:alert] = I18n.t("types.update.error", scope: "decidim.admin")
            render :edit
          end
        end
      end

      def destroy
        enforce_permission_to :destroy, :type, type: type
        type.destroy!

        flash[:notice] = I18n.t("types.destroy.success", scope: "decidim.admin")

        redirect_to "/admin/types/"
      end

      def type
        @type ||= ::DecidimType.find(params[:id])
      end
    end
  end
end
