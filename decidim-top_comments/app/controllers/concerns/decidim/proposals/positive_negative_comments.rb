# frozen_string_literal: true

module Decidim
  module Proposals
    # custom functionality of best-comments
    module PositiveNegativeComments
      extend ActiveSupport::Concern

      included do
        helper_method :in_favor_comments, :against_comments
        helper_method :most_voted_in_favor_comments, :most_voted_against_comments, :percentage_of_comments
        helper_method :in_favor_comments, :most_voted_in_favor_comments, :most_voted_against_comments, :percentage_of_comments
        helper_method :comment_author, :comment_author_avatar, :count_negative_votes_for_comment

        def proposal_comments(proposal_id)
          @proposal_comments ||= Decidim::Comments::Comment.where(decidim_commentable_type: "Decidim::Proposals::Proposal", decidim_commentable_id: proposal_id)
        end

        def in_favor_comments
          @in_favor_comments||= proposal_comments(params[:id]).where(alignment: 1)
        end

        # Ordered from more votes to less
        def most_voted_in_favor_comments
          @most_voted_in_favor_comments = in_favor_comments.joins(:up_votes).select("decidim_comments_comments.*, SUM(decidim_comments_comment_votes.weight) AS vote_sum").group("decidim_comments_comments.*, decidim_comments_comments.id").order(Arel.sql("vote_sum DESC"))
        end

        def percentage_of_comments(num_comments_part)
          tant_per_one= num_comments_part / total_number_of_comments.to_f
          (tant_per_one * 100).round(1)
        end

        def total_number_of_comments
          @total_number_of_comments ||= proposal_comments(params[:id]).size
        end

        def against_comments
          @against_comments||= proposal_comments(params[:id]).where(alignment: -1)
        end

        # Ordered from more votes to less
        def most_voted_against_comments
          @most_voted_negative_comments = against_comments.joins(:up_votes).select("decidim_comments_comments.*, SUM(decidim_comments_comment_votes.weight) AS vote_sum").group("decidim_comments_comments.*, decidim_comments_comments.id").order(Arel.sql("vote_sum DESC"))
        end

        def comment_author(author_id)
          @comment_author = Decidim::User.where(id: author_id).pluck(:name).first
        end

        def comment_author_avatar(author_id)
          @comment_author_avatar = Decidim::User.where(id: author_id).pluck(:avatar).first
        end

        def count_negative_votes_for_comment(comment_id)
          Decidim::Comments::CommentVote.where(decidim_comment_id: comment_id, weight: -1).count
        end
      end
    end
  end
end
