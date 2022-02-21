require 'rails_helper'

RSpec.describe Enrollment, type: :model do

  describe "Instance methods" do

    describe "avg_matches_monthly" do
      subject { enrollment.avg_matches_monthly }

      let!(:enrollment) { create(:enrollment, created_at: Date.today - 2.months - 10.days) }

      context "Without any matches" do
        it "Returns nil" do
          expect(subject).to eq(0)
        end
      end

      context "With 1 reviewed match within 1st month, 3 reviewed matches within second month and 1 reviewed match within uncompleted last month" do
        let!(:another_player) { create(:player, seasons: [enrollment.season]) }

        let!(:match1) { create(:match, :reviewed, competitable: enrollment.season,
                              reviewed_at: enrollment.created_at + 5.days,
                               assignments: [
                                 build(:assignment, side: 1, player: enrollment.player),
                                 build(:assignment, side: 2, player: another_player )
                               ]) }

        let!(:match_f1) { create(:match, :finished, competitable: enrollment.season,
                                finished_at: enrollment.created_at + 5.days,
                              assignments: [
                                build(:assignment, side: 1, player: enrollment.player),
                                build(:assignment, side: 2, player: another_player )
                              ]) }

        let!(:match_f2) { create(:match, :finished, competitable: enrollment.season,
                                finished_at: enrollment.created_at + 5.days,
                                assignments: [
                                  build(:assignment, side: 1, player: enrollment.player),
                                  build(:assignment, side: 2, player: another_player )
                                ]) }

        let!(:match2) { create(:match, :reviewed, competitable: enrollment.season,
                              reviewed_at: enrollment.created_at + 35.days,
                              assignments: [
                                build(:assignment, side: 1, player: enrollment.player),
                                build(:assignment, side: 2, player: another_player )
                              ]) }

        let!(:match3) { create(:match, :reviewed, competitable: enrollment.season,
                              reviewed_at: enrollment.created_at + 35.days,
                              assignments: [
                                build(:assignment, side: 1, player: enrollment.player),
                                build(:assignment, side: 2, player: another_player )
                              ]) }

        let!(:match4) { create(:match, :reviewed, competitable: enrollment.season,
                              reviewed_at: enrollment.created_at + 35.days,
                              assignments: [
                                build(:assignment, side: 1, player: enrollment.player),
                                build(:assignment, side: 2, player: another_player )
                              ]) }

        let!(:match5) { create(:match, :reviewed, competitable: enrollment.season,
                              reviewed_at: enrollment.created_at + 65.days,
                              assignments: [
                                build(:assignment, side: 1, player: enrollment.player),
                                build(:assignment, side: 2, player: another_player )
                              ]) }

        it "Returns average number of reviewed matches monthly: 2" do
          expect(subject).to eq(2)
        end

        context "When 1st month has not yet been reached" do
          before { allow(Time).to receive(:now).and_return(enrollment.created_at + 10.days) }

          it "Return nil" do
            expect(subject).to be_nil
          end
        end

        context "When season ended after 1st month" do
          before { enrollment.season.update_column(:ended_at, enrollment.created_at + 1.month) }

          it "Returns average number of reviewed matches monthly: 2" do
            expect(subject).to eq(1)
          end
        end
      end
    end
  end
end
