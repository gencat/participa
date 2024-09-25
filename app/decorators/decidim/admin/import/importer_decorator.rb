# frozen_string_literal: true

Decidim::Admin::Import::Importer.class_eval do
  def import!
    finished_collection = collection.map { |elem| object_to_manage_without_notify_uniquely?(elem) ? elem.finish_without_notif! : elem.finish! }
    if collection.any? { |elem| elem.is_a? Decidim::Proposals::Import::ProposalCreator }
      notify_collection(finished_collection, :proposals)
    elsif collection.any? { |elem| elem.is_a? Decidim::Proposals::Import::ProposalAnswerCreator }
      notify_collection(finished_collection, :answers)
    end
  end

  def notify_collection(collection, type)
    recipients = collection.map { |elem| elem.participatory_space.followers.uniq }.flatten.uniq
    case type
    when :proposals
      recipients.each do |recipient|
        next unless ["all", "followed-only"].include?(recipient.notification_types)

        ProposalsMailer.notify_massive_import(collection, recipient).deliver_later
      end
    when :answers
      recipients.each do |recipient|
        next unless ["all", "followed-only"].include?(recipient.notification_types)

        ProposalsAnswersMailer.notify_massive_import(collection, recipient).deliver_later
      end
    end
  end

  def object_to_manage_without_notify_uniquely?(obj)
    # These types of object must be notified in group, not uniquely
    [Decidim::Proposals::Import::ProposalCreator, Decidim::Proposals::Import::ProposalAnswerCreator].include? obj.class
  end
end
