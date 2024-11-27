# frozen_string_literal: true

require "rails_helper"

describe "ExternalAuthor" do
  subject { external_author }

  let(:organization) { create(:organization) }
  let(:external_author) { build(:external_author, organization: organization) }

  it { is_expected.to be_valid }

  describe "name" do
    context "when it has a name" do
      let(:second_external_author) { build(:external_author, name: "External Author") }

      it "returns the name" do
        expect(second_external_author.name).to eq("External Author")
      end
    end
  end

  describe "validations" do
    context "when the name is empty" do
      before do
        external_author.name = ""
      end

      it "is not valid" do
        expect(external_author).not_to be_valid
        expect(external_author.errors[:name]).to include("cannot be blank")
      end
    end

    context "when the name already exists" do
      it "cannot have duplicates on the same organization" do
        external_author.save!

        expect(build(:external_author, organization: external_author.organization,
                                       name: external_author.name)).not_to be_valid
      end
    end
  end
end
