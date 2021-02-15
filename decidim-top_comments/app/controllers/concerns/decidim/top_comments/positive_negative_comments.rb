# frozen_string_literal: true

module Decidim
  module TopComments
    # custom functionality of best-comments

    class Presenter
      def initialize(model_type, model_id)
        @model_type= model_type
        @model_id= model_id
      end

      def model_comments
        @model_comments ||= Decidim::Comments::Comment.where(decidim_commentable_type: model_type, decidim_commentable_id: model_id)
      end

      def in_favor_comments
        @in_favor_comments||= model_comments.where(alignment: 1)
      end

      # Ordered from more votes to less
      def most_voted_in_favor_comments
        @most_voted_in_favor_comments = in_favor_comments.joins(:up_votes).select('decidim_comments_comments.*, SUM(decidim_comments_comment_votes.weight) AS vote_sum').group('decidim_comments_comments.*, decidim_comments_comments.id').order(Arel.sql('vote_sum DESC'))
      end

      def percentage_of_comments(num_comments_part)
        tant_per_one= num_comments_part / total_number_of_comments.to_f
        (tant_per_one * 100).round(1)
      end

      def total_number_of_comments
        @total_number_of_comments ||= model_comments.size
      end

      def against_comments
        @against_comments||= model_comments.where(alignment: -1)
      end

      # Ordered from more votes to less
      def most_voted_against_comments
        @most_voted_negative_comments = against_comments.joins(:up_votes).select('decidim_comments_comments.*, SUM(decidim_comments_comment_votes.weight) AS vote_sum').group('decidim_comments_comments.*, decidim_comments_comments.id').order(Arel.sql('vote_sum DESC'))
      end

      private

      attr_reader :model_type, :model_id

    end

    module PositiveNegativeComments
      extend ActiveSupport::Concern

      included do
        helper_method :top_comments_presenter
        helper_method :comment_author, :comment_author_avatar, :count_negative_votes_for_comment

        def top_comments_presenter(model_type, model_id)
          @top_comments_presenter||= ::Decidim::TopComments::Presenter.new(model_type, model_id)
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
