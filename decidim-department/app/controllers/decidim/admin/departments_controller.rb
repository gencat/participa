# frozen_string_literal: true

module Decidim
  module Admin
    # Controller that allows managing all departments at the admin panel.
    #
    class DepartmentsController < Decidim::Admin::ApplicationController
      include Decidim::Admin::Concerns::Administrable
      layout "decidim/admin/extended/settings"

      def index
        enforce_permission_to :read, :department
        @departments = collection
      end

      def collection
        @collection ||= ::DecidimDepartment.all.order(:name)
      end

      def new
        enforce_permission_to :create, :department
        @form = form(DepartmentForm).instance
      end

      def create
        enforce_permission_to :create, :department
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

      def edit
        enforce_permission_to :update, :department, department: department
        @form = form(DepartmentForm).from_model(department)
      end

      def update
        @departments = collection.find(params[:id])
        enforce_permission_to :update, :department, department: department
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

      def destroy
        enforce_permission_to :destroy, :department, department: department
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
