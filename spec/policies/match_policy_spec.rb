require "rails_helper"
require "pundit/rspec"

describe MatchPolicy do
  subject { described_class }

  let!(:player) { create(:player) }
  let!(:match) { create(:match, competitable: build(:season)) }

  
  permissions :edit?, :update? do
    before do
      match.competitable.update_column(:ended_at, nil)
      match.update_column(:ranking_counted, true)
      match.update_column(:accepted_at, 1.hour.ago)
      match.assignments = [
        build(:assignment, player: player, side: 1),
        build(:assignment, player: create(:player), side: 2)
      ]
    end

    context "With conditions met" do
      it "Permits" do
        expect(subject).to permit(player, match)
      end
    end

    context "When season has ended" do
      before { match.competitable.update_column(:ended_at, 2.days.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match is not ranking counted" do
      before { match.update_column(:ranking_counted, false) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has not been accepted" do
      before { match.update_column(:accepted_at, nil) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When player is not assigned to the match" do
      before do
        match.assignments = [
          build(:assignment, player: create(:player), side: 1),
          build(:assignment, player: create(:player), side: 2)
        ]
      end

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end
  end


  permissions :destroy? do
    before do
      match.competitable.update_column(:ended_at, nil)
      match.update_column(:ranking_counted, true)
      match.update_column(:reviewed_at, nil)
      match.update_column(:accepted_at, nil)
      match.update_column(:rejected_at, nil)
      match.assignments = [
        build(:assignment, player: player, side: 1),
        build(:assignment, player: create(:player), side: 2)
      ]
    end

    context "With conditions met" do
      it "Permits" do
        expect(subject).to permit(player, match)
      end
    end

    context "When season has ended" do
      before { match.competitable.update_column(:ended_at, 2.days.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match is not ranking counted" do
      before { match.update_column(:ranking_counted, false) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has been reviewed" do
      before { match.update_columns(accepted_at: 1.minute.ago, finished_at: 1.minute.ago, reviewed_at: 1.minute.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has been accepted" do
      before { match.update_column(:accepted_at, 1.minute.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has been rejected" do
      before { match.update_column(:rejected_at, 1.minute.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When player is assigned as a side 2" do
      before do
        match.assignments = [
          build(:assignment, player: create(:player), side: 1),
          build(:assignment, player: player, side: 2)
        ]
      end

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When player is not assigned to the match" do
      before do
        match.assignments = [
          build(:assignment, player: create(:player), side: 1),
          build(:assignment, player: create(:player), side: 2)
        ]
      end

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end
  end


  permissions :accept?, :reject? do
    before do
      match.competitable.update_column(:ended_at, nil)
      match.update_column(:ranking_counted, true)
      match.update_column(:reviewed_at, nil)
      match.assignments = [
        build(:assignment, player: create(:player), side: 1),
        build(:assignment, player: player, side: 2)
      ]
    end

    context "With conditions met" do
      it "Permits" do
        expect(subject).to permit(player, match)
      end
    end

    context "When season has ended" do
      before { match.competitable.update_column(:ended_at, 2.days.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match is not ranking counted" do
      before { match.update_column(:ranking_counted, false) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has been reviewed" do
      before { match.update_columns(accepted_at: 1.minute.ago, finished_at: 1.minute.ago, reviewed_at: 1.minute.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When player is assigned as a side 1" do
      before do
        match.assignments = [
          build(:assignment, player: player, side: 1),
          build(:assignment, player: create(:player), side: 2)
        ]
      end

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When player is not assigned to the match" do
      before do
        match.assignments = [
          build(:assignment, player: create(:player), side: 1),
          build(:assignment, player: create(:player), side: 2)
        ]
      end

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end
  end


  permissions :finish_init?, :finish? do
    before do
      match.competitable.update_column(:ended_at, nil)
      match.update_column(:ranking_counted, true)
      match.update_column(:accepted_at, 1.hour.ago)
      match.update_column(:rejected_at, nil)
      match.update_column(:reviewed_at, nil)
      match.assignments = [
        build(:assignment, player: player, side: 1),
        build(:assignment, player: create(:player), side: 2)
      ]
    end

    context "With conditions met" do
      it "Permits" do
        expect(subject).to permit(player, match)
      end
    end

    context "When season has ended" do
      before { match.competitable.update_column(:ended_at, 2.days.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match is not ranking counted" do
      before { match.update_column(:ranking_counted, false) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has not been accepted" do
      before { match.update_column(:accepted_at, nil) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has been rejected" do
      before { match.update_column(:rejected_at, 1.hour.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When match has been reviewed" do
      before { match.update_columns(accepted_at: 1.hour.ago, finished_at: 1.hour.ago, reviewed_at: 1.hour.ago) }

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end

    context "When player is not assigned to the match" do
      before do
        match.assignments = [
          build(:assignment, player: create(:player), side: 1),
          build(:assignment, player: create(:player), side: 2)
        ]
      end

      it "Does not permit" do
        expect(subject).not_to permit(player, match)
      end
    end
  end

end
