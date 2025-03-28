# frozen_string_literal: true

module Decidim::Admin::Import::ImporterDecorator
  def self.decorate
    Decidim::Admin::Import::Importer.class_eval do
      def import!
        finished_collection = collection.map { |elem| object_to_manage_without_notify_uniquely?(elem) ? elem.finish_without_notif! : elem.finish! }
        notify_collection(finished_collection, collection.first)
      end

      def notify_collection(collection, klass)
        recipients = collection.flat_map { |elem| elem.participatory_space.followers.where(notification_types: %w(all followed-only)).uniq }.uniq
        case klass
        when Decidim::Proposals::Import::ProposalCreator
          recipients.each { |recipient| ProposalsMailer.notify_massive_import(collection, recipient).deliver_later }
        when Decidim::Proposals::Import::ProposalAnswerCreator
          recipients.each { |recipient| ProposalsAnswersMailer.notify_massive_import(collection, recipient).deliver_later }
        end
      end

      def object_to_manage_without_notify_uniquely?(obj)
        # These types of object must be notified in group, not uniquely
        [Decidim::Proposals::Import::ProposalCreator, Decidim::Proposals::Import::ProposalAnswerCreator].include? obj.class
      end
    end
  end
end

Decidim::Admin::Import::ImporterDecorator.decorate
