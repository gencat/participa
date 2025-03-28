# frozen_string_literal: true

# This decorator override +notifiable?+ to notify events in participatory spaces
module Jobs::Decidim::EventPublisherJobDecorator
  def self.decorate
    Decidim::EventPublisherJob.class_eval do
      private

      def notifiable?
        return false if component && !component.published?

        true
      end
    end
  end
end

Jobs::Decidim::EventPublisherJobDecorator.decorate
