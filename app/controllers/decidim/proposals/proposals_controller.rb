# frozen_string_literal: true

module Decidim
  module Proposals
    # Exposes the proposal resource so users can view and create them.
    class ProposalsController < Decidim::Proposals::ApplicationController
      helper Decidim::WidgetUrlsHelper
      helper ProposalWizardHelper
      helper ParticipatoryTextsHelper
      include Decidim::ApplicationHelper
      include FormFactory
      include FilterResource
      include Decidim::Proposals::Orderable
      include Paginable

      helper_method :form_presenter, :most_voted_positive_comment, :most_voted_negative_comment, :comment_author, :more_positive_comment, :get_comment, :comment_author_avatar, :get_positive_count_comment, :get_negative_count_comment

      before_action :authenticate_user!, only: [:new, :create, :complete]
      before_action :ensure_is_draft, only: [:compare, :complete, :preview, :publish, :edit_draft, :update_draft, :destroy_draft]
      before_action :set_proposal, only: [:show, :edit, :update, :withdraw]
      before_action :edit_form, only: [:edit_draft, :edit]

      before_action :set_participatory_text

      def index
        if component_settings.participatory_texts_enabled?
          @proposals = Decidim::Proposals::Proposal
                       .where(component: current_component)
                       .published
                       .not_hidden
                       .only_amendables
                       .includes(:category, :scope)
                       .order(position: :asc)
          render "decidim/proposals/proposals/participatory_texts/participatory_text"
        else
          @proposals = search
                       .results
                       .published
                       .not_hidden
                       .includes(:category)
                       .includes(:scope)

          @voted_proposals = if current_user
                               ProposalVote.where(
                                 author: current_user,
                                 proposal: @proposals.pluck(:id)
                               ).pluck(:decidim_proposal_id)
                             else
                               []
                             end
          @proposals = paginate(@proposals)
          @proposals = reorder(@proposals)
        end
      end

      def show
        raise ActionController::RoutingError, "Not Found" if @proposal.blank? || !can_show_proposal?

        @report_form = form(Decidim::ReportForm).from_params(reason: "spam")
      end

      def new
        enforce_permission_to :create, :proposal
        @step = :step_1
        if proposal_draft.present?
          redirect_to edit_draft_proposal_path(proposal_draft, component_id: proposal_draft.component.id, question_slug: proposal_draft.component.participatory_space.slug)
        else
          @form = form(ProposalWizardCreateStepForm).from_params({})
        end
      end

      def create
        enforce_permission_to :create, :proposal
        @step = :step_1
        @form = form(ProposalWizardCreateStepForm).from_params(params)

        CreateProposal.call(@form, current_user) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.create.success", scope: "decidim")

            redirect_to Decidim::ResourceLocatorPresenter.new(proposal).path + "/compare"
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.create.error", scope: "decidim")
            render :new
          end
        end
      end

      def compare
        @step = :step_2
        @similar_proposals ||= Decidim::Proposals::SimilarProposals
                               .for(current_component, @proposal)
                               .all

        if @similar_proposals.blank?
          flash[:notice] = I18n.t("proposals.proposals.compare.no_similars_found", scope: "decidim")
          redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path + "/complete"
        end
      end

      def complete
        enforce_permission_to :create, :proposal
        @step = :step_3

        @form = form_proposal_model

        @form.attachment = form_attachment_new
      end

      def preview
        @step = :step_4
      end

      def publish
        @step = :step_4
        PublishProposal.call(@proposal, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("proposals.publish.success", scope: "decidim")
            redirect_to proposal_path(@proposal)
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.publish.error", scope: "decidim")
            render :edit_draft
          end
        end
      end

      def edit_draft
        @step = :step_3
        enforce_permission_to :edit, :proposal, proposal: @proposal
      end

      def update_draft
        @step = :step_1
        enforce_permission_to :edit, :proposal, proposal: @proposal

        @form = form_proposal_params
        UpdateProposal.call(@form, current_user, @proposal) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.update_draft.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(proposal).path + "/preview"
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.update_draft.error", scope: "decidim")
            render :edit_draft
          end
        end
      end

      def destroy_draft
        enforce_permission_to :edit, :proposal, proposal: @proposal

        DestroyProposal.call(@proposal, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("proposals.destroy_draft.success", scope: "decidim")
            redirect_to new_proposal_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.destroy_draft.error", scope: "decidim")
            render :edit_draft
          end
        end
      end

      def edit
        enforce_permission_to :edit, :proposal, proposal: @proposal
      end

      def update
        enforce_permission_to :edit, :proposal, proposal: @proposal

        @form = form_proposal_params
        UpdateProposal.call(@form, current_user, @proposal) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.update.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(proposal).path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.update.error", scope: "decidim")
            render :edit
          end
        end
      end

      def withdraw
        enforce_permission_to :withdraw, :proposal, proposal: @proposal

        WithdrawProposal.call(@proposal, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("proposals.update.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
          on(:has_supports) do
            flash[:alert] = I18n.t("proposals.withdraw.errors.has_supports", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
        end
      end

      private

      def search_klass
        ProposalSearch
      end

      def default_filter_params
        {
          search_text: "",
          origin: "all",
          activity: "",
          category_id: "",
          state: "except_rejected",
          scope_id: nil,
          related_to: "",
          type: "all"
        }
      end

      def proposal_draft
        Proposal.from_all_author_identities(current_user).not_hidden.only_amendables
                .where(component: current_component).find_by(published_at: nil)
      end

      def ensure_is_draft
        @proposal = Proposal.not_hidden.where(component: current_component).find(params[:id])
        redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path unless @proposal.draft?
      end

      def set_proposal
        @proposal = Proposal.published.not_hidden.where(component: current_component).find(params[:id])
      end

      # Returns true if the proposal is NOT an emendation or the user IS an admin.
      # Returns false if the proposal is not found or the proposal IS an emendation
      # and is NOT visible to the user based on the component's amendments settings.
      def can_show_proposal?
        return true if @proposal&.amendable? || current_user&.admin?

        Proposal.only_visible_emendations_for(current_user, current_component).published.include?(@proposal)
      end

      def form_proposal_params
        form(ProposalForm).from_params(params)
      end

      def form_proposal_model
        form(ProposalForm).from_model(@proposal)
      end

      def form_presenter
        @form_presenter ||= present(@form, presenter_class: Decidim::Proposals::ProposalPresenter)
      end

      def form_attachment_new
        form(AttachmentForm).from_params({})
      end

      def edit_form
        form_attachment_model = form(AttachmentForm).from_model(@proposal.attachments.first)
        @form = form_proposal_model
        @form.attachment = form_attachment_model
        @form
      end

      def set_participatory_text
        @participatory_text = Decidim::Proposals::ParticipatoryText.find_by(component: current_component)
      end

      def most_voted_positive_comment
        @most_voted_positive_comment = Decidim::Comments::Comment.where(decidim_commentable_type: "Decidim::Proposals::Proposal", decidim_commentable_id: params[:id], alignment: 1)
      end

      def more_positive_comment(comment_id, auxID)
        @more_positive_comment = (ActiveRecord::Base.connection.execute("SELECT * FROM decidim_comments_comment_votes where decidim_comment_id = "+comment_id.to_s+" AND weight = 1").count < ActiveRecord::Base.connection.execute("SELECT * FROM decidim_comments_comment_votes where decidim_comment_id = "+auxID.to_s+" AND weight = 1").count)
      end

      def get_comment(comment_id)
        Decidim::Comments::Comment.where(id: comment_id)
      end

      def most_voted_negative_comment
        @most_voted_negative_comment = Decidim::Comments::Comment.where(decidim_commentable_type: "Decidim::Proposals::Proposal", decidim_commentable_id: params[:id], alignment: -1)
      end

      def comment_author(author_id)
        @comment_author = Decidim::User.where(id: author_id).pluck(:name).first
      end

      def comment_author_avatar(author_id)
        @comment_author_avatar = Decidim::User.where(id: author_id).pluck(:avatar).first
      end

      def get_positive_count_comment(comment_id)
        @get_positive_count_comment = ActiveRecord::Base.connection.execute("SELECT * FROM decidim_comments_comment_votes where decidim_comment_id = "+comment_id.to_s+" AND weight = 1").count
      end

      def get_negative_count_comment(comment_id)
        @get_negative_count_comment = ActiveRecord::Base.connection.execute("SELECT * FROM decidim_comments_comment_votes where decidim_comment_id = "+comment_id.to_s+" AND weight = -1").count
      end
    end
  end
end
