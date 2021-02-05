# frozen_string_literal: true

module Decidim
  module Proposals
    # custom functionality of best-comments
    module PositiveNegativeComments
      extend ActiveSupport::Concern

      included do
        helper_method :in_favor_comments, :most_voted_negative_comment, :comment_author, :more_positive_comment, :get_comment, :comment_author_avatar, :count_positive_votes_for_comment, :count_negative_votes_for_comment

        def in_favor_comments
          @in_favor_comments||= Decidim::Comments::Comment.where(decidim_commentable_type: "Decidim::Proposals::Proposal", decidim_commentable_id: params[:id], alignment: 1)
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

        def count_positive_votes_for_comment(comment_id)
          Decidim::Comments::CommentVote.where(decidim_comment_id: comment_id, weight: 1).count
        end

        def count_negative_votes_for_comment(comment_id)
          Decidim::Comments::CommentVote.where(decidim_comment_id: comment_id, weight: -1).count
        end
      end
    end
  end
end
