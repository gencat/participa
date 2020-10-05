# frozen_string_literal: true

Decidim::Proposals::ProposalsController.class_eval do
  include ::Decidim::Proposals::PositiveNegativeComments

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
                           Decidim::Proposals::ProposalVote.where(
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

  private

  def default_filter_category_params
    return "all" unless current_component.participatory_space.categories.any?

    ["all"] + current_component.participatory_space.categories.map { |category| category.id.to_s }
  end

  # Returns true if the proposal is NOT an emendation or the user IS an admin.
  # Returns false if the proposal is not found or the proposal IS an emendation
  # and is NOT visible to the user based on the component's amendments settings.
  def can_show_proposal?
    return true if @proposal&.amendable? || current_user&.admin?

    Decidim::Proposals::Proposal.only_visible_emendations_for(current_user, current_component).published.include?(@proposal)
  end
end
