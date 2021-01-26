# frozen_string_literal: true

require "rails_helper"

describe "Most Voted Comments", type: :system do
  let(:organization) do
    create(
      :organization,
      name: "Participa Gencat",
      default_locale: :ca,
      available_locales: [:ca],
    )
  end
  # forcing nickname and slug as they are randomly failing in Decidim v0.22, remove them after upgrading to v0.23
  let!(:process) { create(:participatory_process, :with_steps, slug: 'most-voted-comments-process', organization: organization) }
  let!(:component) { create(:proposal_component, participatory_space: process) }
  let!(:author) { create(:user, :confirmed, nickname: 'commenter', organization: organization) }
  let!(:commentable) { create(:proposal, component: component, users: [author]) }

  let(:resource_path) { resource_locator(commentable).path }

  before do
    switch_to_host(organization.host)
    login_as author, scope: :user
  end

  context "when there are no comments" do
    it "renders the block empty" do
      visit resource_path
      expect(page).to have_selector("#most-voted-comments")
      expect(page).to have_content("COMENTARIS MÉS VOTATS")
      expect(page).to_not have_selector(".comment-in-favor")
      expect(page).to_not have_selector(".comment-against")
    end
  end

  context "when there are comments" do
    let!(:comment_for) { create(:comment, author: author, commentable: commentable, alignment: 1) }
    let!(:comment_neutral) { create(:comment, author: author, commentable: commentable, alignment: 0) }
    let!(:comment_against) { create(:comment, author: author, commentable: commentable, alignment: -1) }

    it "when the comments don't have votes most voted comments should be empty" do
      visit resource_path
      expect(page).to_not have_selector(".comment-in-favor")
      expect(page).to_not have_selector(".comment-against")
    end

    context "when votes go to the neutral comment" do
      let!(:vote) { create(:comment_vote, :up_vote, author: author, comment: comment_neutral)}

      it "most voted comments should be empty" do
        visit resource_path
        expect(page).to_not have_selector(".comment-in-favor")
        expect(page).to_not have_selector(".comment-against")
      end
    end

    context "when there is a voted comment which is in Favor" do
      let!(:vote) { create(:comment_vote, :up_vote, author: author, comment: comment_for)}

      it "most voted comments should render the comment in favor" do
        visit resource_path
        expect(page).to have_selector(".comment-in-favor")
        comment= find(".comment-in-favor")
        expect(comment).to have_text(comment_for.body)
        expect(page).to_not have_selector(".comment-against")
      end
    end

    context "when there is a voted comment which is Against" do
      let!(:vote) { create(:comment_vote, :up_vote, author: author, comment: comment_against)}

      it "most voted comments should render the comment against" do
        visit resource_path
        expect(page).to_not have_selector(".comment-in-favor")
        expect(page).to have_selector(".comment-against")
        comment= find(".comment-against")
        expect(comment).to have_text(comment_against.body)
      end
    end

    context "when there are voted comments in Favor and Against" do
      let!(:vote_1) { create(:comment_vote, :up_vote, author: author, comment: comment_for)}
      let!(:vote_2) { create(:comment_vote, :up_vote, author: author, comment: comment_against)}

      it "most voted comments should render both comments" do
        visit resource_path
        expect(page).to have_selector(".comment-in-favor")
        comment= find(".comment-in-favor")
        expect(comment).to have_text(comment_for.body)
        expect(page).to have_selector(".comment-against")
        comment= find(".comment-against")
        expect(comment).to have_text(comment_against.body)
      end
    end
  end
end
