# frozen_string_literal: true

module Decidim
  module Proposals
    # Exposes the proposal resource so users can view and create them.
    class ProposalsController < Decidim::Proposals::ApplicationController
      helper Decidim::WidgetUrlsHelper
      helper ProposalWizardHelper
      include FormFactory
      include FilterResource
      include Orderable
      include Paginable

      helper_method :geocoded_proposals, :most_voted_positive_comment, :most_voted_negative_comment, :comment_author, :more_positive_comment, :get_comment, :comment_author_avatar, :get_positive_count_comment, :get_negative_count_comment, :process_categories, :has_categories, :get_id, :process_name, :my_category
      before_action :authenticate_user!, only: [:new, :create, :complete]
      before_action :ensure_is_draft, only: [:preview, :publish, :edit_draft, :update_draft, :destroy_draft]

      def index
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

        if params.has_key?(:filter)
          @category_id = params[:filter][:category_id]
        else
          @category_id = ""
        end
      end

      def show
        @proposal = Proposal.published.not_hidden.where(component: current_component).find(params[:id])
        @report_form = form(Decidim::ReportForm).from_params(reason: "spam")
      end

      def new
        enforce_permission_to :create, :proposal
        @step = :step_1
        if proposal_draft.present?
          redirect_to edit_draft_proposal_path(proposal_draft, component_id: proposal_draft.component.id, question_slug: proposal_draft.component.participatory_space.slug)
        else
          @form = form(ProposalForm).from_params(params)
        end
      end

      def create
        enforce_permission_to :create, :proposal
        @step = :step_3
        @form = form(ProposalForm).from_params(params)

        CreateProposal.call(@form, current_user) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.create.success", scope: "decidim")

            redirect_to Decidim::ResourceLocatorPresenter.new(proposal).path + "/preview"
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.create.error", scope: "decidim")
            render :complete
          end
        end
      end

      def compare
        @step = :step_2
        @similar_proposals ||= Decidim::Proposals::SimilarProposals
                               .for(current_component, params[:proposal])
                               .all
        @form = form(ProposalForm).from_params(params)

        if @similar_proposals.blank?
          flash[:notice] = I18n.t("proposals.proposals.compare.no_similars_found", scope: "decidim")
          redirect_to complete_proposals_path(proposal: { title: @form.title, body: @form.body })
        end
      end

      def complete
        enforce_permission_to :create, :proposal
        @step = :step_3
        if params[:proposal].present?
          params[:proposal][:attachment] = form(AttachmentForm).from_params({})
          @form = form(ProposalForm).from_params(params)
        else
          @form = form(ProposalForm).from_params(
            attachment: form(AttachmentForm).from_params({})
          )
        end
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

        @form = form(ProposalForm).from_model(@proposal)
      end

      def update_draft
        @step = :step_1
        enforce_permission_to :edit, :proposal, proposal: @proposal

        @form = form(ProposalForm).from_params(params)
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
        @proposal = Proposal.published.not_hidden.where(component: current_component).find(params[:id])
        enforce_permission_to :edit, :proposal, proposal: @proposal

        @form = form(ProposalForm).from_model(@proposal)
      end

      def update
        @proposal = Proposal.not_hidden.where(component: current_component).find(params[:id])
        enforce_permission_to :edit, :proposal, proposal: @proposal

        @form = form(ProposalForm).from_params(params)
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
        @proposal = Proposal.published.not_hidden.where(component: current_component).find(params[:id])
        enforce_permission_to :withdraw, :proposal, proposal: @proposal

        WithdrawProposal.call(@proposal, current_user) do
          on(:ok) do |_proposal|
            flash[:notice] = I18n.t("proposals.update.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
          on(:invalid) do
            flash[:alert] = I18n.t("proposals.update.error", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
        end
      end

      private

      def geocoded_proposals
        @geocoded_proposals ||= search.results.not_hidden.select(&:geocoded?)
      end

      def search_klass
        ProposalSearch
      end

      def default_filter_params
        {
          search_text: "",
          origin: "all",
          activity: "",
          category_id: "",
          state: "not_withdrawn",
          scope_id: nil,
          related_to: ""
        }
      end

      def proposal_draft
        Proposal.from_all_user_identities(current_user).not_hidden.where(component: current_component).find_by(published_at: nil)
      end

      def ensure_is_draft
        @proposal = Proposal.not_hidden.where(component: current_component).find(params[:id])
        redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path unless @proposal.draft?
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

      def process_categories(my_slug)
        @process_categories ||= Decidim::Category.where(decidim_participatory_space_id: get_id(my_slug), decidim_participatory_space_type: "Decidim::ParticipatoryProcess")
      end

      def has_categories(my_slug)
        @has_categories = Decidim::Category.where(decidim_participatory_space_id: get_id(my_slug), decidim_participatory_space_type: "Decidim::ParticipatoryProcess").any?
      end

      def my_category(category_id)
        @my_category = Decidim::Category.where(id: category_id)
      end

      def get_id(my_slug)
        @get_id = Decidim::ParticipatoryProcess.where(slug: my_slug)
      end

      def process_name(my_slug)
        @process_name ||= Decidim::ParticipatoryProcess.where(slug: my_slug)
      end
    end
  end
end
