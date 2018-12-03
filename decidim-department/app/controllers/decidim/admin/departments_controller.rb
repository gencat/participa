# frozen_string_literal: true

require_dependency "decidim/admin/application_controller"
# require_dependency "../models/decidim/department/abilities/admin_user"
require_dependency "../commands/decidim/admin/update_department"
require_dependency "../commands/decidim/admin/create_department"

module Decidim
  module Admin
    # Controller that allows managing all departments at the admin panel.
    #
    class DepartmentsController < Decidim::Admin::ApplicationController
      layout "decidim/admin/extended/settings"

      def index
        # authorize! :index, Department
        @departments = collection
      end

      def collection
        @collection ||= ::DecidimDepartment.all.order(:name)
      end

      def edit
        # authorize! :update, Department
        @form = form(DepartmentForm).from_model(department)
      end

      def update
        @departments = collection.find(params[:id])
        # authorize! :update, Department
        @form = form(DepartmentForm).from_params(params)

        UpdateDepartment.call(department, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("scopes.update.success", scope: "decidim.admin")
            redirect_to "/admin/departments"
          end
          on(:exists) do
            flash.now[:alert] = I18n.t("departments.create.exists", scope: "decidim.admin")
            render :edit
          end
          on(:invalid) do
            flash.now[:alert] = I18n.t("scopes.update.error", scope: "decidim.admin")
            render :edit
          end
        end
      end

      def new
        # authorize! :new, Department
        @form = form(DepartmentForm).instance
      end

      def create
        # authorize! :new, Department
        @form = form(DepartmentForm).from_params(params)

        CreateDepartment.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("departments.create.success", scope: "decidim.admin")
            redirect_to "/admin/departments"
          end
          on(:exists) do
            flash.now[:alert] = I18n.t("departments.create.exists", scope: "decidim.admin")
            render :new
          end
          on(:invalid) do
            flash.now[:alert] = I18n.t("departments.create.error", scope: "decidim.admin")
            render :new
          end
        end
      end

      def destroy
        # authorize! :destroy, Department
        department.destroy!

        flash[:notice] = I18n.t("departments.destroy.success", scope: "decidim.admin")

        redirect_to "/admin/departments/"
      end

      def department
        @department ||= ::DecidimDepartment.find(params[:id])
      end

    end
  end
end
