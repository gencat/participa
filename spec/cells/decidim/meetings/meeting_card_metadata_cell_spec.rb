# frozen_string_literal: true

require "rails_helper"

describe Decidim::Meetings::MeetingCardMetadataCell, type: :cell do
  subject { cell("decidim/meetings/meeting_card_metadata", meeting).call }

  let(:participatory_process) { create(:participatory_process, :published, title: { en: "Process of the meeting", ca: "Procés de la trobada" }) }
  let(:component) { create(:meeting_component, :published, participatory_space: participatory_process) }
  let(:meeting) { create(:meeting, :published, component:) }
  let(:process_title) { translated(participatory_process.title) }

  controller Decidim::Meetings::MeetingsController

  context "when the meeting is shown outside any participatory space" do
    before { allow(controller).to receive(:current_participatory_space).and_return(nil) }

    it "shows the participatory process of the meeting" do
      expect(subject).to have_text(process_title)
    end
  end

  context "when the meeting is shown in another participatory space" do
    before { allow(controller).to receive(:current_participatory_space).and_return(create(:participatory_process)) }

    it "shows the participatory process of the meeting" do
      expect(subject).to have_text(process_title)
    end
  end

  context "when the meeting is shown in its own participatory space" do
    before { allow(controller).to receive(:current_participatory_space).and_return(participatory_process) }

    it "does not show the participatory process" do
      expect(subject).to have_no_text(process_title)
    end
  end
end
