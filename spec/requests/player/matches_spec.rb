require 'rails_helper'

RSpec.describe "Player::Matches", type: :request do

  let!(:season) { create(:season, ended_at: nil) }

  describe "POST /player/matches" do
    subject { post player_matches_path, params: { player_id: requested_player.id } }

    let!(:player) { create(:player) }
    let!(:requested_player) { create(:player) }

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "And player and requested player are enrolled to selected_season" do

        let!(:enrollment_p) { create(:enrollment, player: player, season: season, canceled_at: nil) }
        let!(:enrollment_rp) { create(:enrollment, player: requested_player, season: season, canceled_at: nil) }

        context "And has no other single pending match against requested player" do

          it "Creates the match and redirects to requested player page" do
            expect { subject }.to change { Match.count }.by(1)
            match = Match.order(:created_at).last
            expect(match.requested_at).not_to be_nil
            expect(match.published_at).not_to be_nil
            expect(match.accepted_at).to be_nil
            expect(match.rejected_at).to be_nil
            expect(match.finished_at).to be_nil
            expect(match.reviewed_at).to be_nil
            expect(match.assignments.find { |a| a.side == 1 }.player).to eq(player)
            expect(match.assignments.find { |a| a.side == 2 }.player).to eq(requested_player)

            expect(response).to redirect_to player_path(requested_player)
          end
        end

        context "And has other double requested match against requested player" do

          let!(:match) { create(:match, :requested, competitable: season,
                                assignments: [
                                  build(:assignment, side: 1, player: player),
                                  build(:assignment, side: 1),
                                  build(:assignment, side: 2),
                                  build(:assignment, side: 2, player: requested_player)
                                ]) }

          it "Creates the match and redirects to requested player page" do
            expect { subject }.to change { Match.count }.by(1)
            match = Match.order(:created_at).last
            expect(match.requested_at).not_to be_nil
            expect(match.published_at).not_to be_nil
            expect(match.accepted_at).to be_nil
            expect(match.rejected_at).to be_nil
            expect(match.finished_at).to be_nil
            expect(match.reviewed_at).to be_nil
            expect(match.assignments.find { |a| a.side == 1 }.player).to eq(player)
            expect(match.assignments.find { |a| a.side == 2 }.player).to eq(requested_player)

            expect(response).to redirect_to player_path(requested_player)
          end
        end

        context "And has other single rejected match against requested player" do

          let!(:match) { create(:match, :rejected, competitable: season,
                                assignments: [
                                  build(:assignment, side: 1, player: requested_player),
                                  build(:assignment, side: 2, player: player),
                                ]) }

          it "Creates the match and redirects to requested player page" do
            expect { subject }.to change { Match.count }.by(1)
            match = Match.order(:created_at).last
            expect(match.requested_at).not_to be_nil
            expect(match.published_at).not_to be_nil
            expect(match.accepted_at).to be_nil
            expect(match.rejected_at).to be_nil
            expect(match.finished_at).to be_nil
            expect(match.reviewed_at).to be_nil
            expect(match.assignments.find { |a| a.side == 1 }.player).to eq(player)
            expect(match.assignments.find { |a| a.side == 2 }.player).to eq(requested_player)

            expect(response).to redirect_to player_path(requested_player)
          end

        end

        context "And has other single finished match against requested player" do

          let!(:match) { create(:match, :finished, competitable: season, winner_side: 1,
                                assignments: [
                                  build(:assignment, side: 1, player: player),
                                  build(:assignment, side: 2, player: requested_player),
                                ]) }

          it "Creates the match and redirects to requested player page" do
            expect { subject }.to change { Match.count }.by(1)
            match = Match.order(:created_at).last
            expect(match.requested_at).not_to be_nil
            expect(match.published_at).not_to be_nil
            expect(match.accepted_at).to be_nil
            expect(match.rejected_at).to be_nil
            expect(match.finished_at).to be_nil
            expect(match.reviewed_at).to be_nil
            expect(match.assignments.find { |a| a.side == 1 }.player).to eq(player)
            expect(match.assignments.find { |a| a.side == 2 }.player).to eq(requested_player)

            expect(response).to redirect_to player_path(requested_player)
          end

        end

        context "And has other single accepted match against requested player" do

          context "In an open season" do
            let!(:match) { create(:match, :accepted, competitable: season,
                                  assignments: [
                                    build(:assignment, side: 1, player: requested_player),
                                    build(:assignment, side: 2, player: player),
                                  ]) }

            it "Does not create the match" do
              expect { subject }.not_to change { Match.count }
              expect(response).to redirect_to player_path(requested_player)
            end
          end

          context "In an ended season" do
            let!(:match) { create(:match, :accepted, competitable: create(:season, :ended, created_at: 1.year.ago, name: "#{Date.today.year - 1}"),
                                  assignments: [
                                    build(:assignment, side: 1, player: requested_player),
                                    build(:assignment, side: 2, player: player),
                                  ]) }

            it "Creates the match and redirects to requested player page" do
              expect { subject }.to change { Match.count }.by(1)
              match = Match.order(:created_at).last
              expect(match.requested_at).not_to be_nil
              expect(match.published_at).not_to be_nil
              expect(match.accepted_at).to be_nil
              expect(match.rejected_at).to be_nil
              expect(match.finished_at).to be_nil
              expect(match.reviewed_at).to be_nil
              expect(match.assignments.find { |a| a.side == 1 }.player).to eq(player)
              expect(match.assignments.find { |a| a.side == 2 }.player).to eq(requested_player)

              expect(response).to redirect_to player_path(requested_player)
            end
          end
        end

        context "And has other single requested match against requested player" do

          context "In an open season" do
            let!(:match) { create(:match, :requested, competitable: season,
                                  assignments: [
                                    build(:assignment, side: 1, player: player),
                                    build(:assignment, side: 2, player: requested_player),
                                  ]) }

            it "Does not create the match" do
              expect { subject }.not_to change { Match.count }
              expect(response).to redirect_to player_path(requested_player)
            end
          end

          context "In an ended season" do
            let!(:match) { create(:match, :requested, competitable: create(:season, :ended, created_at: 1.year.ago, name: "#{Date.today.year - 1}"),
                                  assignments: [
                                    build(:assignment, side: 1, player: requested_player),
                                    build(:assignment, side: 2, player: player),
                                  ]) }

            it "Creates the match and redirects to requested player page" do
              expect { subject }.to change { Match.count }.by(1)
              match = Match.order(:created_at).last
              expect(match.requested_at).not_to be_nil
              expect(match.published_at).not_to be_nil
              expect(match.accepted_at).to be_nil
              expect(match.rejected_at).to be_nil
              expect(match.finished_at).to be_nil
              expect(match.reviewed_at).to be_nil
              expect(match.assignments.find { |a| a.side == 1 }.player).to eq(player)
              expect(match.assignments.find { |a| a.side == 2 }.player).to eq(requested_player)

              expect(response).to redirect_to player_path(requested_player)
            end
          end
        end
      end


      context "And player is enrolled to selected_season but requested player is not" do

        let!(:enrollment_p) { create(:enrollment, player: player, season: season, canceled_at: nil) }
        let!(:enrollment_rp) { create(:enrollment, player: requested_player, season: season, canceled_at: 1.hour.ago) }

        it "Does not create the match" do
          expect { subject }.not_to change { Match.count }
          expect(response).to redirect_to player_path(requested_player)
        end
      end


      context "And requested player is enrolled to selected_season but player is not" do

        let!(:enrollment_rp) { create(:enrollment, player: requested_player, season: season, canceled_at: nil) }

        it "Does not create the match" do
          expect { subject }.not_to change { Match.count }
          expect(response).to redirect_to player_path(requested_player)
        end
      end
    end


    context "When no player is logged in" do

      let!(:enrollment_p) { create(:enrollment, player: player, season: season, canceled_at: nil) }
      let!(:enrollment_rp) { create(:enrollment, player: requested_player, season: season, canceled_at: nil) }

      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end
end
