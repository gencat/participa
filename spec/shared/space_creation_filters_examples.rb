# frozen_string_literal: true

shared_examples "a space filterable by creation date and creator" do
  let(:organization) { create(:organization) }
  let(:admin) { create(:user, :admin, :confirmed, organization:) }

  def search(params)
    described_class.where(organization:).ransack(params, auth_object: admin).result
  end

  def create_space(whodunnit: nil, **attributes)
    PaperTrail.request(whodunnit:) { create(factory, organization:, **attributes) }
  end

  describe "created_at_from_date" do
    let!(:on_day_start) { create_space(created_at: Time.zone.local(2026, 1, 20, 0, 0, 0)) }
    let!(:day_before) { create_space(created_at: Time.zone.local(2026, 1, 19, 23, 59, 59)) }
    let!(:days_after) { create_space(created_at: Time.zone.local(2026, 3, 1, 12, 0, 0)) }

    it "returns the spaces created from the beginning of the given day" do
      expect(search(created_at_from_date: "2026-01-20")).to contain_exactly(on_day_start, days_after)
    end
  end

  describe "created_at_to_date" do
    let!(:on_day_end) { create_space(created_at: Time.zone.local(2026, 1, 20, 23, 59, 59)) }
    let!(:day_after) { create_space(created_at: Time.zone.local(2026, 1, 21, 0, 0, 0)) }
    let!(:days_before) { create_space(created_at: Time.zone.local(2025, 12, 1, 12, 0, 0)) }

    it "returns the spaces created until the end of the given day" do
      expect(search(created_at_to_date: "2026-01-20")).to contain_exactly(on_day_end, days_before)
    end
  end

  describe "created_at_from_date and created_at_to_date" do
    let!(:before_range) { create_space(created_at: Time.zone.local(2026, 1, 9, 23, 59, 59)) }
    let!(:range_start) { create_space(created_at: Time.zone.local(2026, 1, 10, 0, 0, 0)) }
    let!(:range_end) { create_space(created_at: Time.zone.local(2026, 1, 20, 23, 59, 59)) }
    let!(:after_range) { create_space(created_at: Time.zone.local(2026, 1, 21, 0, 0, 0)) }

    it "returns the spaces created within the range, both days included" do
      expect(search(created_at_from_date: "2026-01-10", created_at_to_date: "2026-01-20"))
        .to contain_exactly(range_start, range_end)
    end

    it "returns the spaces created on a single day when both dates are the same" do
      create_space(created_at: Time.zone.local(2026, 1, 15, 12, 0, 0)).tap do |same_day|
        expect(search(created_at_from_date: "2026-01-15", created_at_to_date: "2026-01-15")).to contain_exactly(same_day)
      end
    end
  end

  context "when the date is not valid" do
    let!(:space) { create_space }

    it "ignores the filter" do
      expect(search(created_at_from_date: "not-a-date", created_at_to_date: "2026-13-45")).to contain_exactly(space)
    end
  end

  describe "creator_search" do
    let(:creator) { create(:user, :confirmed, organization:, name: "Ana Puig Serra", nickname: "anapuig", email: "ana.puig@example.org") }
    let(:other_user) { create(:user, :confirmed, organization:, name: "Joan Ribas", nickname: "jribas", email: "joan.ribas@example.org") }

    let!(:created_by_creator) { create_space(whodunnit: creator.to_gid.to_s) }
    let!(:created_by_other) { create_space(whodunnit: other_user.to_gid.to_s) }
    let!(:without_creator) { create_space }

    it "finds the spaces created by a user by part of the name, ignoring case" do
      expect(search(creator_search: "puig serra")).to contain_exactly(created_by_creator)
    end

    it "finds the spaces created by a user by nickname" do
      expect(search(creator_search: "anapu")).to contain_exactly(created_by_creator)
    end

    it "finds the spaces created by a user by email" do
      expect(search(creator_search: "ana.puig@example")).to contain_exactly(created_by_creator)
    end

    it "returns nothing when no creator matches" do
      expect(search(creator_search: "nobody-matches")).to be_empty
    end

    it "does not filter when the value is blank" do
      expect(search(creator_search: "")).to contain_exactly(created_by_creator, created_by_other, without_creator)
    end

    context "when the version stores the creator as a plain user id" do
      let!(:created_by_creator) { create_space(whodunnit: creator.id.to_s) }

      it "finds the spaces created by that user" do
        expect(search(creator_search: "anapuig")).to contain_exactly(created_by_creator)
      end
    end

    context "when another user updates the space" do
      before do
        PaperTrail.request(whodunnit: other_user.to_gid.to_s) do
          created_by_creator.update!(title: { en: "Updated title" })
        end
      end

      it "still matches the creator" do
        expect(search(creator_search: "anapuig")).to contain_exactly(created_by_creator)
      end

      it "does not match the user who updated it" do
        expect(search(creator_search: "jribas")).to contain_exactly(created_by_other)
      end
    end

    context "when the space is duplicated" do
      let(:duplicator) { create(:user, :admin, :confirmed, organization:, name: "Marta Duplicadora", nickname: "mduplica") }
      let!(:copy) { duplicate_space.call(created_by_creator, duplicator) }

      it "assigns the copy to the user who duplicated it" do
        expect(copy).to be_persisted
        expect(search(creator_search: "mduplica")).to contain_exactly(copy)
        expect(search(creator_search: "anapuig")).to contain_exactly(created_by_creator)
      end
    end

    it "can be combined with the creation date filters" do
      created_by_creator.update!(created_at: Time.zone.local(2026, 1, 15, 10, 0, 0))
      create_space(whodunnit: creator.to_gid.to_s, created_at: Time.zone.local(2026, 2, 15, 10, 0, 0))

      expect(search(creator_search: "anapuig", created_at_from_date: "2026-01-01", created_at_to_date: "2026-01-31"))
        .to contain_exactly(created_by_creator)
    end
  end
end
