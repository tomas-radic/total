require 'rails_helper'

RSpec.describe Match, type: :model do

  let!(:season) { create(:season) }

  describe "Validations" do

    describe "existing_matches" do
      subject { build(:match,
                      competitable: season,
                      requested_at: Time.now,
                      accepted_at: nil,
                      rejected_at: nil,
                      finished_at: nil,
                      assignments: [
                        build(:assignment, side: 1, player: player1),
                        build(:assignment, side: 2, player: player2)
                      ]) }

      let!(:player1) { create(:player, seasons: [season]) }
      let!(:player2) { create(:player, seasons: [season]) }

      context "When other single, unfinished, unaccepted, unrejected match exists" do
        let!(:other_match) { create(:match,
                                    competitable: competitable,
                                    requested_at: Time.now,
                                    accepted_at: nil,
                                    rejected_at: nil,
                                    finished_at: nil,
                                    assignments: [
                                      build(:assignment, side: 1, player: player2),
                                      build(:assignment, side: 2, player: player1)
                                    ]) }

        context "In the same season" do
          let!(:competitable) { season }

          it "Is not valid" do
            expect(subject).not_to be_valid
          end
        end

        context "In another season" do
          let!(:competitable) { create(:season,
                                       name: "#{Date.today.year - 1}",
                                       ended_at: 1.year.ago,
                                       players: [player1, player2]) }

          it "Is valid" do
            expect(subject).to be_valid
          end

        end

        context "In the tournament of the same season" do
          let!(:competitable) { create(:tournament, season: season) }

          it "Is valid" do
            expect(subject).to be_valid
          end
        end
      end

      context "When other single rejected unfinished match exists in the same season" do
        let!(:other_match) { create(:match,
                                    competitable: season,
                                    requested_at: Time.now,
                                    accepted_at: nil,
                                    rejected_at: Time.now,
                                    finished_at: nil,
                                    assignments: [
                                      build(:assignment, side: 1, player: player2),
                                      build(:assignment, side: 2, player: player1)
                                    ]) }

        it "Is valid" do
          expect(subject).to be_valid
        end

      end

      context "When other single finished match exists in the same season" do
        let!(:other_match) { create(:match,
                                    competitable: season,
                                    requested_at: Time.now,
                                    accepted_at: Time.now,
                                    rejected_at: nil,
                                    finished_at: Time.now,
                                    winner_side: 1,
                                    set1_side1_score: 6,
                                    set1_side2_score: 4,
                                    assignments: [
                                      build(:assignment, side: 1, player: player2),
                                      build(:assignment, side: 2, player: player1)
                                    ]) }

        it "Is valid" do
          expect(subject).to be_valid
        end

      end

      context "When other double, unfinished, unaccepted, unrejected match exists" do
        let!(:player3) { create(:player, seasons: [season]) }
        let!(:player4) { create(:player, seasons: [season]) }
        let!(:other_match) { create(:match,
                                    competitable: season,
                                    requested_at: Time.now,
                                    accepted_at: nil,
                                    rejected_at: nil,
                                    finished_at: nil,
                                    assignments: [
                                      build(:assignment, side: 1, player: player4),
                                      build(:assignment, side: 1, player: player3),
                                      build(:assignment, side: 2, player: player2),
                                      build(:assignment, side: 2, player: player1)
                                    ]) }

        it "Is valid" do
          expect(subject).to be_valid
        end
      end
    end


    describe "player_assignments" do
      subject { build(:match,
                      competitable: competitable,
                      requested_at: Time.now,
                      accepted_at: nil,
                      rejected_at: nil,
                      finished_at: nil,
                      assignments: assignments) }

      let!(:player1) { create(:player) }
      let!(:player2) { create(:player) }

      context "When match doesn't belong to a tournament" do
        let!(:competitable) { season }

        context "When all players are enrolled to the season" do
          before do
            season.players << player1
            season.players << player2
          end

          context "When number of assignments is correct" do
            let(:assignments) do
              [
                build(:assignment, side: 1, player: player1),
                build(:assignment, side: 2, player: player2)
              ]
            end

            it "Is valid" do
              expect(subject).to be_valid
            end
          end

          context "When number of assignments is not correct" do
            let(:assignments) do
              [
                build(:assignment, side: 2, player: player2)
              ]
            end

            it "Is not valid" do
              expect(subject).not_to be_valid
            end
          end

        end

        context "When assigned player is not enrolled to the season" do
          before do
            season.players << player1
          end

          let(:assignments) do
            [
              build(:assignment, side: 1, player: player1),
              build(:assignment, side: 2, player: player2)
            ]
          end

          it "Is not valid" do
            expect(subject).not_to be_valid
          end
        end

        context "When assigned player is anonymized" do
          before do
            player1.update_column(:anonymized_at, Time.now)
            season.players << player1
            season.players << player2
          end

          let(:assignments) do
            [
              build(:assignment, side: 1, player: player1),
              build(:assignment, side: 2, player: player2)
            ]
          end

          context "And the match is not finished yet" do

            it "Is not valid" do
              expect(subject).not_to be_valid
            end
          end

          context "And the match is finished" do
            before do
              subject.accepted_at = Time.now
              subject.finished_at = Time.now
              subject.set1_side1_score = 6
              subject.set1_side2_score = 4
              subject.winner_side = 1
            end

            it "Is valid" do
              expect(subject).to be_valid
            end
          end
        end
      end

      context "When match belongs to a tournament and players are not enrolled to the season" do
        let!(:competitable) { create(:tournament, season: season) }

        context "When number of assignments is correct" do
          let(:assignments) do
            [
              build(:assignment, side: 1, player: player1),
              build(:assignment, side: 2, player: player2)
            ]
          end

          it "Is valid" do
            expect(subject).to be_valid
          end

        end

        context "When number of assignments is not correct" do
          let(:assignments) do
            [
              build(:assignment, side: 2, player: player1)
            ]
          end

          it "Is not valid" do
            expect(subject).not_to be_valid
          end
        end

        context "When assigned player is anonymized" do
          before do
            player1.update_column(:anonymized_at, Time.now)
          end

          let(:assignments) do
            [
              build(:assignment, side: 1, player: player1),
              build(:assignment, side: 2, player: player2)
            ]
          end

          context "And the match is not finished yet" do

            it "Is not valid" do
              expect(subject).not_to be_valid
            end
          end

          context "And the match is finished" do
            before do
              subject.accepted_at = Time.now
              subject.finished_at = Time.now
              subject.set1_side1_score = 6
              subject.set1_side2_score = 4
              subject.winner_side = 1
            end

            it "Is valid" do
              expect(subject).to be_valid
            end
          end
        end
      end
    end


    describe "result_state" do
      subject { build(:match,
                      competitable: season,
                      requested_at: Time.now,
                      accepted_at: Time.now,
                      rejected_at: nil,
                      finished_at: Time.now,
                      winner_side: 2,
                      assignments: [
                        build(:assignment, side: 1, player: player1),
                        build(:assignment, side: 2, player: player2)
                      ]) }

      let!(:player1) { create(:player, seasons: [season]) }
      let!(:player2) { create(:player, seasons: [season]) }


      context "When none of the players retired the match" do

        context "With sets score 1:2" do
          before do
            subject.set1_side1_score = 6
            subject.set1_side2_score = 3
            subject.set2_side1_score = 4
            subject.set2_side2_score = 6
            subject.set3_side1_score = 1
            subject.set3_side2_score = 6
          end

          it "Is valid" do
            expect(subject).to be_valid
          end
        end

        context "With sets score 1:1" do
          before do
            subject.set1_side1_score = 6
            subject.set1_side2_score = 3
            subject.set2_side1_score = 4
            subject.set2_side2_score = 6
          end

          it "Is not valid" do
            expect(subject).not_to be_valid
          end
        end
      end

      context "When any of the players retired the match" do

        before do
          subject.assignments.sample.tap do |a|
            a.is_retired = true
          end
        end

        context "With sets score 1:2" do
          before do
            subject.set1_side1_score = 6
            subject.set1_side2_score = 3
            subject.set2_side1_score = 4
            subject.set2_side2_score = 6
            subject.set3_side1_score = 1
            subject.set3_side2_score = 6
          end

          it "Is valid" do
            expect(subject).to be_valid
          end
        end

        context "With sets score 1:1" do
          before do
            subject.set1_side1_score = 6
            subject.set1_side2_score = 3
            subject.set2_side1_score = 4
            subject.set2_side2_score = 6
          end

          it "Is valid" do
            expect(subject).to be_valid
          end
        end
      end
    end

  end


  describe "Instance methods" do

    describe "finish" do

      subject { match.finish attributes }

      let!(:match) { create(:match,
                            competitable: season,
                            requested_at: Time.now,
                            accepted_at: nil,
                            rejected_at: nil,
                            finished_at: nil,
                            assignments: [
                              build(:assignment, side: 1, player: player1),
                              build(:assignment, side: 2, player: player2)
                            ]) }

      let!(:player1) { create(:player, seasons: [season]) }
      let!(:player2) { create(:player, seasons: [season]) }
      let!(:place) { create(:place) }
      let(:play_date) { Date.yesterday }
      let(:notes) { "Great match." }


      context "With accepted match" do
        before { match.update_column(:accepted_at, Time.now) }

        context "Match has not been retired" do
          let(:attributes) do
            {
              "score" => "6 4 1 6 6 3",
              "score_side" => 2,
              "retired_player_id" => "",
              "play_date" => play_date.to_s,
              "place_id" => place.id,
              "notes" => notes
            }
          end

          it "Correctly finishes and returns the match" do
            result = subject

            result.reload
            expect(result).to be_a(Match)
            expect(result).to have_attributes(
                                set1_side1_score: 4,
                                set1_side2_score: 6,
                                set2_side1_score: 6,
                                set2_side2_score: 1,
                                set3_side1_score: 3,
                                set3_side2_score: 6,
                                winner_side: 2,
                                play_date: play_date,
                                notes: notes
                              )

            expect(result.finished_at).not_to be_nil
            expect(result.reviewed_at).not_to be_nil
            expect(result.assignments.find { |a| a.is_retired? }).to be_nil
          end
        end

        context "Match has been retired" do
          let(:attributes) do
            {
              "score" => "6 4 1 6 5 3",
              "score_side" => 1,
              "retired_player_id" => player1.id,
              "play_date" => play_date.to_s,
              "place_id" => place.id,
              "notes" => notes
            }
          end

          it "Correctly finishes and returns the match" do
            result = subject

            result.reload
            expect(result).to be_a(Match)
            expect(result).to have_attributes(
                                set1_side1_score: 6,
                                set1_side2_score: 4,
                                set2_side1_score: 1,
                                set2_side2_score: 6,
                                set3_side1_score: 5,
                                set3_side2_score: 3,
                                winner_side: 2,
                                play_date: play_date,
                                notes: notes
                              )

            expect(result.finished_at).not_to be_nil
            expect(result.reviewed_at).not_to be_nil
            expect(result.assignments.find { |a| a.is_retired? }.player_id).to eq(player1.id)
          end
        end

        context "With incorrect score attribute" do
          let(:attributes) do
            {
              "score" => "6 4 1 6 5 ",
              "score_side" => 1,
              "retired_player_id" => "",
              "play_date" => play_date.to_s,
              "place_id" => place.id,
              "notes" => notes
            }
          end

          it "Stores the error and does not finish the match" do
            result = subject

            result.reload
            expect(result).to be_a(Match)
            expect(result).to have_attributes(
                                set1_side1_score: nil,
                                set1_side2_score: nil,
                                set2_side1_score: nil,
                                set2_side2_score: nil,
                                set3_side1_score: nil,
                                set3_side2_score: nil,
                                finished_at: nil,
                                reviewed_at: nil,
                                winner_side: nil,
                                play_date: nil,
                                notes: nil
                              )

            expect(result.errors[:score].first).to eq("Neplatný výsledok zápasu.")
          end
        end

        context "When season is ended" do
          before do
            season.update_column(:ended_at, Time.now)
          end

          let(:attributes) do
            {
              "score" => "6 4",
              "score_side" => 1,
              "retired_player_id" => "",
              "play_date" => play_date.to_s,
              "place_id" => place.id,
              "notes" => notes
            }
          end

          it "Stores the error and does not finish the match" do
            result = subject

            result.reload
            expect(result).to be_a(Match)
            expect(result).to have_attributes(
                                set1_side1_score: nil,
                                set1_side2_score: nil,
                                set2_side1_score: nil,
                                set2_side2_score: nil,
                                set3_side1_score: nil,
                                set3_side2_score: nil,
                                finished_at: nil,
                                reviewed_at: nil,
                                winner_side: nil,
                                play_date: nil,
                                notes: nil
                              )

            expect(result.errors[:season].first).to eq("Sezóna je už skončená.")
          end
        end
      end

      context "With unaccepted match" do
        let(:attributes) do
          {
            "score" => "6 4",
            "score_side" => 1,
            "retired_player_id" => "",
            "play_date" => play_date.to_s,
            "place_id" => place.id,
            "notes" => notes
          }
        end

        it "Stores the error and does not finish the match" do
          result = subject

          result.reload
          expect(result).to be_a(Match)
          expect(result).to have_attributes(
                              set1_side1_score: nil,
                              set1_side2_score: nil,
                              set2_side1_score: nil,
                              set2_side2_score: nil,
                              set3_side1_score: nil,
                              set3_side2_score: nil,
                              finished_at: nil,
                              reviewed_at: nil,
                              winner_side: nil,
                              play_date: nil,
                              notes: nil
                            )

          expect(result.errors[:status].first).to eq("Zápas nie je akceptovaný súperom.")
        end
      end
    end
  end

end
