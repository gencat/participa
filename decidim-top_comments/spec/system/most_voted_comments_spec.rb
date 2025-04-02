# frozen_string_literal: true

require "spec_helper"

describe "Most Voted Comments", type: :system do
  let(:organization) do
    create(
      :organization,
      name: "Participa Gencat",
      default_locale: :en,
      available_locales: [:ca, :en]
    )
  end
  let!(:process) { create(:participatory_process, :with_steps, organization: organization) }
  let!(:author) { create(:user, :confirmed, organization: organization) }

  let(:resource_path) { resource_locator(commentable).path }

  before do
    switch_to_host(organization.host)
    login_as author, scope: :user
  end

  shared_examples "has top_comments" do
    context "when there are no comments" do
      it "renders the block empty" do
        visit resource_path
        expect(page).to have_css(".most-voted-comments")
        expect(page).to have_content("Most voted comments")
        expect(page).to have_no_css(".comment-in-favor")
        expect(page).to have_no_css(".comment-against")

        expect(page).to have_content("0\nin favor\n(0%)")
        expect(page).to have_content("0\nagainst\n(0%)")
      end
    end

    context "when there are comments" do
      let!(:comment_for) { create(:comment, author: author, commentable: commentable, alignment: 1) }
      let!(:comment_neutral) { create(:comment, author: author, commentable: commentable, alignment: 0) }
      let!(:comment_against) { create(:comment, author: author, commentable: commentable, alignment: -1) }

      it "when the comments don't have votes most voted comments should be empty" do
        visit resource_path
        expect(page).to have_no_css(".comment-in-favor")
        expect(page).to have_no_css(".comment-against")
      end

      it "shows the number of each kind of comments" do
        visit resource_path

        expect(page).to have_content("1\nin favor\n(33.3%)")
        expect(page).to have_content("1\nagainst\n(33.3%)")
      end

      context "when votes go to the neutral comment" do
        let!(:vote) { create(:comment_vote, :up_vote, author: author, comment: comment_neutral) }

        it "most voted comments should be empty" do
          visit resource_path
          expect(page).to have_no_css(".comment-in-favor")
          expect(page).to have_no_css(".comment-against")
        end
      end

      context "when there is a voted comment which is in Favor" do
        let!(:vote) { create(:comment_vote, :up_vote, author: author, comment: comment_for) }

        it "most voted comments should render the comment in favor" do
          visit resource_path
          expect(page).to have_css(".comment-in-favor")
          comment= find(".comment-in-favor")
          expect(comment).to have_text(comment_for.body["en"])
          expect(page).to have_no_css(".comment-against")
        end
      end

      context "when there is a voted comment which is Against" do
        let!(:vote) { create(:comment_vote, :up_vote, author: author, comment: comment_against) }

        it "most voted comments should render the comment against" do
          visit resource_path
          expect(page).to have_no_css(".comment-in-favor")
          expect(page).to have_css(".comment-against")
          comment= find(".comment-against")
          expect(comment).to have_text(comment_against.body["en"])
        end
      end

      context "when there are voted comments in Favor and Against" do
        let!(:vote1) { create(:comment_vote, :up_vote, author: author, comment: comment_for) }
        let!(:vote2) { create(:comment_vote, :up_vote, author: author, comment: comment_against) }

        it "most voted comments should render both comments" do
          visit resource_path
          expect(page).to have_css(".comment-in-favor")
          comment= find(".comment-in-favor")
          expect(comment).to have_text(comment_for.body["en"])
          expect(page).to have_css(".comment-against")
          comment= find(".comment-against")
          expect(comment).to have_text(comment_against.body["en"])
        end
      end
    end
  end

  describe "proposals with top_comments" do
    let!(:component) { create(:proposal_component, participatory_space: process) }
    let!(:commentable) { create(:proposal, component: component, users: [author]) }

    it_behaves_like "has top_comments"
  end

  describe "debates with top_comments" do
    let!(:component) { create(:debates_component, participatory_space: process) }
    let!(:commentable) { create(:debate, component: component) }

    it_behaves_like "has top_comments"
  end
end
