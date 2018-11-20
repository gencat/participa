# frozen_string_literal: true

require_dependency "decidim/admin/application_controller"
# require_dependency "../models/decidim/type/abilities/admin_user"
require_dependency "../commands/decidim/admin/update_type"
require_dependency "../commands/decidim/admin/create_type"

module Decidim
  module Admin
    # Controller that allows managing all types at the admin panel.
    #
    class TypesController < Decidim::Admin::ApplicationController
      skip_authorization_check
      layout "decidim/admin/extended/settings"
       
      def index
        authorize! :index, Type
        @types = collection
      end

      def collection
        @collection ||= ::DecidimType.all.order(:name)
      end
      
      def edit
        authorize! :update, Type
        @form = form(TypeForm).from_model(type)
      end

      def update
        @types = collection.find(params[:id])
        authorize! :update, Type
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

      def new
        authorize! :new, Type
        @form = form(TypeForm).instance
      end

      def create
        authorize! :new, Type
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


      def destroy
        authorize! :destroy, Type
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
