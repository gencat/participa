# frozen_string_literal: true

Decidim::Forms::UserAnswersSerializer.class_eval do
  def serialize
    @answers.each_with_index.inject({}) do |serialized, (answer)|
      serialized_map = serialized.keys.map { |key| key }.flatten

      if !serialized_map.include?(translated_attribute(answer.question.body))
        serialized.update(
          answer_translated_attribute_name(:id) => answer.session_token,
          answer_translated_attribute_name(:created_at) => answer.created_at.to_s(:db),
          answer_translated_attribute_name(:ip_hash) => answer.ip_hash,
          answer_translated_attribute_name(:user_status) => answer_translated_attribute_name(answer.decidim_user_id.present? ? "registered" : "unregistered"),
          translated_attribute(answer.question.body) => normalize_body(answer)
        )
      else
        serialized
      end
    end
  end
end
