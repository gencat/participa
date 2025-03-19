# frozen_string_literal: true

require "rails_helper"

describe Decidim::Admin::NewslettersHelper do
  include Decidim::Admin::NewslettersHelper

  let(:current_locale) { I18n.locale }

  describe "#label_text_for" do
    let(:manifest) { Decidim::ParticipatorySpaceManifest.new name: "participatory_processes" }
    let(:space_type) { Decidim::Admin::SelectiveNewsletterParticipatorySpaceTypeForm.from_model(manifest:) }

    context "when space_type has a process_group" do
      let(:process_group) { create(:participatory_process_group, id: 3) }

      before do
        space_type.process_group_id= process_group.id
      end

      it "returns the title of the process_group" do
        expect(label_text_for(space_type)).to eq(process_group.title[I18n.locale])
      end
    end

    context "when the space_type does not have a process_group" do
      before do
        space_type.process_group_id= nil
      end

      it "returns the translation" do
        expect(label_text_for(space_type)).to eq(t("activerecord.models.decidim/#{space_type.manifest_name.singularize}.other"))
      end
    end
  end
end
