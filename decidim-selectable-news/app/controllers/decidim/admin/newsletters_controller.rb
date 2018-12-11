# frozen_string_literal: true

module Decidim
  module Admin
    # Controller that allows managing newsletters.
    #
    class NewslettersController < Decidim::Admin::ApplicationController
      include Decidim::NewslettersHelper

      helper_method :get_all_processes, :get_process_component_id, :get_process_proposals_ids, :get_users_from_proposals, :get_mails_from_users, :process_has_follows

      def index
        authorize! :index, Newsletter
        @newsletters = collection.order(Newsletter.arel_table[:created_at].desc)
      end

      def new
        authorize! :create, Newsletter
        @form = form(NewsletterForm).instance
      end

      def show
        @newsletter = collection.find(params[:id])
        @email = NewsletterMailer.newsletter(current_user, @newsletter)
        authorize! :read, @newsletter
      end

      def preview
        @newsletter = collection.find(params[:id])
        authorize! :read, @newsletter

        email = NewsletterMailer.newsletter(current_user, @newsletter)
        Premailer::Rails::Hook.perform(email)

        render html: email.html_part.body.decoded.html_safe
      end

      def create
        authorize! :create, Newsletter
        @form = form(NewsletterForm).from_params(params)

        CreateNewsletter.call(@form, current_user) do
          on(:ok) do |newsletter|
            flash.now[:notice] = I18n.t("newsletters.create.success", scope: "decidim.admin")
            redirect_to action: :show, id: newsletter.id
          end

          on(:invalid) do |newsletter|
            @newsletter = newsletter
            flash.now[:error] = I18n.t("newsletters.create.error", scope: "decidim.admin")
            render action: :new
          end
        end
      end

      def edit
        @newsletter = collection.find(params[:id])
        authorize! :update, @newsletter
        @form = form(NewsletterForm).from_model(@newsletter)
      end

      def update
        @newsletter = collection.find(params[:id])
        authorize! :update, Newsletter
        @form = form(NewsletterForm).from_params(params)

        UpdateNewsletter.call(@newsletter, @form, current_user) do
          on(:ok) do |newsletter|
            flash.now[:notice] = I18n.t("newsletters.update.success", scope: "decidim.admin")
            redirect_to action: :show, id: newsletter.id
          end

          on(:invalid) do |newsletter|
            @newsletter = newsletter
            flash.now[:error] = I18n.t("newsletters.update.error", scope: "decidim.admin")
            render action: :edit
          end
        end
      end

      def destroy
        @newsletter = collection.find(params[:id])
        authorize! :destroy, @newsletter

        DestroyNewsletter.call(@newsletter, current_user) do
          on(:already_sent) do
            flash.now[:error] = I18n.t("newsletters.destroy.error_already_sent", scope: "decidim.admin")
            redirect_to :back
          end

          on(:ok) do
            flash[:notice] = I18n.t("newsletters.destroy.success", scope: "decidim.admin")
            redirect_to action: :index
          end
        end
      end

      def deliver
        @newsletter = collection.find(params[:id])
        authorize! :update, @newsletter

        DeliverNewsletter.call(@newsletter, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("newsletters.deliver.success", scope: "decidim.admin")
            redirect_to action: :index
          end

          on(:invalid) do
            flash[:error] = I18n.t("newsletters.deliver.error", scope: "decidim.admin")
            redirect_to action: :show
          end
        end
      end

      def deliver_custom_process
        @newsletter = collection.find(params[:id])
        authorize! :update, @newsletter

        DeliverNewsletter.call(@newsletter, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("newsletters.deliver.success", scope: "decidim.admin")
            redirect_to action: :index
          end

          on(:invalid) do
            flash[:error] = I18n.t("newsletters.deliver.error", scope: "decidim.admin")
            redirect_to action: :show
          end
        end
      end

      private

      def collection
        Newsletter.where(organization: current_organization)
      end

      def get_all_processes
        @get_all_processes ||= Decidim::ParticipatoryProcess.all
      end

      def get_process_component_id (process_id)
        @get_process_proposal_id = Decidim::Component.where(participatory_space_id: process_id, manifest_name: "proposals")
      end

      def get_process_proposals_ids(component_id)
        @get_process_proposal_ids = Decidim::Proposals::Proposal.where(decidim_component_id: component_id)
      end

      def get_users_from_proposals (proposal_id)
        @get_users_from_proposals = Decidim::Follow.where(decidim_followable_id: proposal_id, decidim_followable_type: "Decidim::Proposals::Proposal")
      end

      def get_mails_from_users (user_id)
        @get_mails_from_proposals = Decidim::User.where(id: user_id)
      end

      def process_has_follows(process_id)
        components = Decidim::Component.where(participatory_space_id: process_id, manifest_name: "proposals")

        components.each do |component|

          proposals = Decidim::Proposals::Proposal.where(decidim_component_id: component.id)

          proposals.each do |proposal|

            follows = Decidim::Follow.where(decidim_followable_id: proposal.id, decidim_followable_type: "Decidim::Proposals::Proposal")

            follows.each do |follow|

              users = Decidim::User.where(id: follow.decidim_user_id)

              users.each do |user|
                return "true"
              end
              return "false"
            end
          end
        end
      end
    end
  end
end
