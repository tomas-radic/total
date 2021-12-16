require 'rails_helper'

RSpec.describe "Player::Matches", type: :request do

  let!(:player) { create(:player, name: "Player") }

  describe "POST /player/matches" do
    subject { post player_matches_path, params: { player_id: requested_player.id } }

    let!(:requested_player) { create(:player) }

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With existing season" do
        let!(:season) { create(:season, ended_at: nil) }
        before do
          season.players << player
          season.players << requested_player
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

        context "When requested player is anonymized" do
          before { requested_player.update_column(:anonymized_at, Time.now) }

          it "Raises error" do
            expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context "When no season even exists" do
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

    let!(:match) { create(:match, :accepted, ranking_counted: true, competitable: build(:season)) }

    context "When player is logged in" do
      before do
        sign_in player
      end

      context "When logged in player is a player of the match" do
        before do
          match.assignments = [
            build(:assignment, side: 1, player: player),
            build(:assignment, side: 2, player: build(:player, seasons: [match.season]))
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

    let!(:match) do
      create(:match, :requested, :accepted, competitable: build(:season), ranking_counted: true)
    end
    let!(:player) { create(:player, name: "Player", seasons: [match.season]) }
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
          competitable_id: create(:tournament, season: match.season).id,
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
            build(:assignment, side: 2, player: build(:player, seasons: [match.season]))
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
                               competitable_id: match.season.id,
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


  describe "POST /player/matches/:id/accept" do
    subject { post accept_player_match_path(match) }

    let!(:match) do
      create(:match, :requested, competitable: build(:season), ranking_counted: true)
    end
    let!(:player1) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }
    let!(:player2) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }
    let!(:another_player) { create(:player, seasons: [match.season]) }

    before do
      match.assignments = [
        build(:assignment, side: 1, player: player1),
        build(:assignment, side: 2, player: player2)
      ]

      match.save!
    end

    context "When logged in player is a side 2 player of the match" do
      before do
        sign_in player2
      end

      it "Accepts the match and cancels open_to_play_since flag of both players" do
        subject

        expect(match.reload.accepted_at).not_to be_nil
        expect(player1.reload.open_to_play_since).to be_nil
        expect(player2.reload.open_to_play_since).to be_nil
      end
    end

    context "When logged in player is a side 1 player of the match" do
      before do
        sign_in player1
      end

      it "Raises error" do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "When logged in player is not a player of the match" do
      before do
        sign_in another_player
      end

      it "Raises error" do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "When player is NOT logged in" do
      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end


  describe "POST /player/matches/:id/reject" do
    subject { post reject_player_match_path(match) }

    let!(:match) do
      create(:match, :requested, competitable: build(:season), ranking_counted: true)
    end
    let!(:player1) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }
    let!(:player2) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }
    let!(:another_player) { create(:player, seasons: [match.season]) }

    before do
      match.assignments = [
        build(:assignment, side: 1, player: player1),
        build(:assignment, side: 2, player: player2)
      ]

      match.save!
    end

    context "When logged in player is a side 2 player of the match" do
      before do
        sign_in player2
      end

      it "Rejects the match and preserves open_to_play_since flag of both players" do
        subject

        expect(match.reload.rejected_at).not_to be_nil
        expect(player1.reload.open_to_play_since).not_to be_nil
        expect(player2.reload.open_to_play_since).not_to be_nil
      end
    end

    context "When logged in player is a side 1 player of the match" do
      before do
        sign_in player1
      end

      it "Raises error" do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "When logged in player is not a player of the match" do
      before do
        sign_in another_player
      end

      it "Raises error" do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "When player is NOT logged in" do
      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end


  describe "POST /player/matches/:id/finish" do
    subject { post finish_player_match_path(match), params: params }

    let!(:season) { create(:season) }
    let!(:player) { create(:player, name: "Player", seasons: [season]) }
    let!(:match) { create(:match, :accepted, ranking_counted: true, competitable: season,
                          assignments: [
                            build(:assignment, player: player, side: 1),
                            build(:assignment, player: create(:player, seasons: [season]), side: 2)
                          ]) }
    let(:params) do
      {}
    end

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With unfinished match" do
        context "When match has been successfully finished" do
          before do
            match.update_column(:set1_side1_score, 6)
            match.update_column(:set1_side1_score, 4)
            match.update_column(:finished_at, Time.now)
            expect_any_instance_of(Match).to(
              receive(:finish).and_return(match))
          end

          it "Redirects to the match page" do
            subject

            expect(response).to redirect_to match_path(match)
          end

        end

        context "When match has not been finished" do
          before do
            expect_any_instance_of(Match).to(
              receive(:finish).and_return(match))
          end

          it "Renders finish_init" do
            subject

            expect(response).to render_template(:finish_init)
          end
        end
      end

      context "With reviewed match" do
        before do
          match.update!(
            finished_at: Time.now,
            reviewed_at: Time.now,
            set1_side1_score: 6,
            set1_side2_score: 3,
            winner_side: 1
          )
        end

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
end
