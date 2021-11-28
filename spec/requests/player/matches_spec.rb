require 'rails_helper'

RSpec.describe "Player::Matches", type: :request do

  let!(:season) { create(:season, ended_at: nil) }
  let!(:player) { create(:player, seasons: [season]) }

  describe "POST /player/matches" do
    subject { post player_matches_path, params: { player_id: requested_player.id } }

    let!(:requested_player) { create(:player, seasons: [season]) }

    context "When player is logged in" do

      before do
        sign_in player
      end

      it "Creates new match and redirects" do
        expect { subject }.to change { Match.count }.by(1)

        expect(response).to redirect_to(player_path(requested_player))
      end

      context "With ended season" do
        before { season.update_column(:ended_at, 24.hours.ago) }

        it "Does not create a match and redirects" do
          expect { subject }.not_to change { Match.count }

          expect(response).to redirect_to(player_path(requested_player))
        end
      end
    end


    context "When player is NOT logged in" do

      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end


  describe "GET /player/matches/:id/edit" do
    subject { get edit_player_match_path(match) }

    let!(:match) { create(:match, :accepted, ranking_counted: true, competitable: season) }

    context "When player is logged in" do
      before do
        sign_in player
      end

      context "When logged in player is a player of the match" do
        before do
          match.assignments = [
            build(:assignment, side: 1, player: player),
            build(:assignment, side: 2, player: build(:player, seasons: [season]))
          ]
        end

        it "Renders edit" do
          expect(subject).to render_template(:edit)
        end

      end

      context "When logged in player is NOT a player of the match" do

        it "Raises error" do
          expect { subject }.to raise_error(Pundit::NotAuthorizedError)
        end

      end
    end


    context "When player is NOT logged in" do

      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end


  describe "PATCH /player/matches/:id" do
    subject { patch player_match_path(match), params: params }

    let!(:match) { create(:match, :requested, :accepted, competitable: season, ranking_counted: true) }
    let!(:place) { create(:place) }
    let(:play_date) { Date.tomorrow }
    let(:play_time) { Match.play_times.keys.sample }

    let(:valid_params) do
      {
        match: {
          play_date: play_date.to_s,
          play_time: play_time,
          notes: "A note about this match.",
          kind: "double",
          winner_side: 1,
          accepted_at: Time.now,
          reviewed_at: Time.now,
          finished_at: Time.now,
          ranking_counted: false,
          competitable_type: "Tournament",
          competitable_id: create(:tournament, season: season).id,
          place_id: place.id,
          set1_side1_score: 6,
          set1_side2_score: 4,
          set2_side1_score: 6,
          set2_side2_score: 4,
          set3_side1_score: 6,
          set3_side2_score: 4
        }
      }
    end

    context "When player is logged in" do
      before do
        sign_in player
      end

      context "When logged in player is a player of the match" do
        before do
          match.assignments = [
            build(:assignment, side: 1, player: player),
            build(:assignment, side: 2, player: build(:player, seasons: [season]))
          ]

          match.save!
        end

        context "With valid params" do
          let(:params) { valid_params }

          it "Updates only whitelisted attributes and redirects" do
            subject

            match.reload
            expect(match).to have_attributes(
                               play_date: play_date,
                               play_time: play_time,
                               notes: "A note about this match.",
                               kind: "single",
                               winner_side: nil,
                               reviewed_at: nil,
                               finished_at: nil,
                               ranking_counted: true,
                               competitable_type: "Season",
                               competitable_id: season.id,
                               place_id: place.id,
                               set1_side1_score: nil,
                               set1_side2_score: nil,
                               set2_side1_score: nil,
                               set2_side2_score: nil,
                               set3_side1_score: nil,
                               set3_side2_score: nil
                             )

            expect(response).to redirect_to(match_path match)
          end
        end

        # context "With invalid params" (currently no params are invalid)
      end

      context "When logged in player is NOT a player of the match" do
        let(:params) { valid_params }

        it "Raises error" do
          expect { subject }.to raise_error(Pundit::NotAuthorizedError)
        end

      end
    end


    context "When player is NOT logged in" do
      let(:params) { valid_params }

      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end
end
