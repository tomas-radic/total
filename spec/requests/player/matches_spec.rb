require 'rails_helper'
require 'shared_examples/player_examples'

RSpec.describe "Player::Matches", type: :request do

  let!(:player) { create(:player, name: "Player") }

  describe "POST /player/matches" do
    subject { post player_matches_path, params: { player_id: requested_player.id } }

    it_behaves_like "player_request"


    let!(:season) { create(:season) }
    let!(:requested_player) { create(:player) }

    context "When player is logged in" do

      before do
        sign_in player
      end


      before do
        season.players << player
        season.players << requested_player
      end

      it "Creates new match and redirects" do
        expect { subject }.to change { Match.count }.by(1)
        expect(response).to redirect_to(match_path(Match.order(:created_at).last))
      end

      context "When current player is marked as cant_play_since" do
        before { player.update_column(:cant_play_since, 2.days.ago) }

        it "Unsets cant_play_since attribute" do
          subject

          expect(player.reload.cant_play_since).to be_nil
        end
      end
    end
  end


  describe "GET /player/matches/:id/edit" do
    subject { get edit_player_match_path(match) }

    it_behaves_like "player_request"


    let!(:match) { create(:match, :accepted, ranking_counted: true, competitable: build(:season)) }

    context "When player is logged in" do
      before do
        sign_in player
      end

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
  end


  describe "PATCH /player/matches/:id" do
    subject { patch player_match_path(match), params: params }

    it_behaves_like "player_request"


    let!(:match) do
      create(:match, :requested, :accepted, competitable: build(:season), ranking_counted: true)
    end
    let!(:player) { create(:player, name: "Player", seasons: [match.season]) }
    let!(:place) { create(:place) }
    let(:play_date) { Date.tomorrow }
    let(:play_time) { Match.play_times.keys.sample }

    let(:params) do
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

      before do
        match.assignments = [
          build(:assignment, side: 1, player: player),
          build(:assignment, side: 2, player: build(:player, seasons: [match.season]))
        ]

        match.save!
      end

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

      # context "With invalid params" (currently no params are invalid)

    end
  end


  describe "POST /player/matches/:id/accept" do
    subject { post accept_player_match_path(match) }

    it_behaves_like "player_request"


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

      it "Accepts match and cancels open_to_play_since flag of both players" do
        subject

        expect(match.reload.accepted_at).not_to be_nil
        expect(player1.reload.open_to_play_since).to be_nil
        expect(player2.reload.open_to_play_since).to be_nil
      end
    end
  end


  describe "POST /player/matches/:id/reject" do
    subject { post reject_player_match_path(match) }

    it_behaves_like "player_request"


    let!(:match) do
      create(:match, :requested, competitable: build(:season), ranking_counted: true)
    end
    let!(:player1) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }
    let!(:player2) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }

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

      it "Rejects it and preserves open_to_play_since flag of both players" do
        subject

        expect(match.reload.rejected_at).not_to be_nil
        expect(player1.reload.open_to_play_since).not_to be_nil
        expect(player2.reload.open_to_play_since).not_to be_nil
      end
    end
  end


  describe "POST /player/matches/:id/finish" do
    subject { post finish_player_match_path(match), params: params }

    it_behaves_like "player_request"

    let(:params) do
      { score: "6 4" }
    end
    let!(:season) { create(:season) }
    let!(:player) { create(:player, name: "Player", seasons: [season]) }
    let!(:match) { create(:match, :accepted, ranking_counted: true, competitable: season,
                          assignments: [
                            build(:assignment, player: player, side: 1),
                            build(:assignment, player: create(:player, seasons: [season]), side: 2)
                          ]) }


    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With valid score" do
        let(:params) do
          { score: "6 4" }
        end

        it "Finishes match and redirects to the match" do
          subject

          expect(match.reload.finished_at).not_to be_nil
          expect(response).to redirect_to match_path(match)
        end

      end

      context "With invalid score" do
        let(:params) do
          { score: "6" }
        end

        it "Does not finish the match and renders finish_init" do
          subject

          expect(match.reload.finished_at).to be_nil
          expect(response).to render_template(:finish_init)
        end
      end
    end
  end


  describe "POST /player/matches/:id/cancel" do
    subject { post cancel_player_match_path(match) }

    it_behaves_like "player_request"


    let!(:match) do
      create(:match, :accepted, competitable: build(:season), ranking_counted: true)
    end
    let!(:player1) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }
    let!(:player2) { create(:player, open_to_play_since: Time.now, seasons: [match.season]) }

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

      it "Rejects match and preserves open_to_play_since flag of both players" do
        subject

        expect(match.reload.canceled_at).not_to be_nil
      end
    end
  end


  describe "POST /player/matches/:id/toggle_reaction" do
    subject { post toggle_reaction_player_match_path(match) }

    let!(:match) { create(:match) }

    it_behaves_like "player_request"

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "When player does not have reaction for the match yet" do

        it "Creates reaction" do
          subject

          expect(match.reload.reactions.find_by(player: player)).not_to be_nil
        end
      end

      context "When player already has reaction for the match" do
        before { create(:reaction, reactionable: match, player: player) }

        it "Destroys reaction" do
          subject

          expect(match.reload.reactions.find_by(player: player)).to be_nil
        end
      end
    end
  end


  describe "POST /player/matches/:id/switch_prediction" do
    subject { post switch_prediction_player_match_path(match, params: attributes) }

    let!(:player) { create(:player) }
    let!(:match) { create(:match) }

    let(:attributes) do
      { side: 2 }
    end

    it_behaves_like "player_request"

    context "When player is logged in" do

      before { sign_in player }

      context "When player has no existing prediction to the match" do


        it "Creates new prediction and redirects" do
          subject

          expect(player.reload.predictions.find_by(match: match, side: attributes[:side])).not_to be_nil
        end
      end


      context "When player has existing prediction with the same side" do
        let!(:existing_prediction) { create(:prediction, match: match, player: player, side: 2) }

        it "Destroys the existing prediction" do
          subject

          expect(player.reload.predictions.find_by(match: match)).to be_nil
        end

      end


      context "When player has existing prediction with different side" do
        let!(:existing_prediction) { create(:prediction, match: match, player: player, side: 1) }

        it "Switches the prediction to the new side" do
          subject

          expect(player.reload.predictions.find_by(match: match, side: attributes[:side])).not_to be_nil
        end

      end


      context "With reviewed match" do
        before { match.update_column(:reviewed_at, 1.minute.ago) }

        it "Does not create prediction and redirects" do
          subject

          expect(player.reload.predictions.find_by(match: match)).to be_nil
        end
      end


      context "When it is not allowed to predict that match" do
        before { match.update_column(:predictions_disabled_since, Time.now) }

        it "Does not create prediction" do
          subject

          expect(player.reload.predictions.find_by(match: match)).to be_nil
        end
      end


      context "When match is not published" do
        before { match.update_column(:published_at, nil) }

        it "Does not create prediction and redirects" do
          subject

          expect(response).to redirect_to(not_found_path)
          expect(player.reload.predictions.find_by(match: match)).to be_nil
        end
      end
    end
  end

end
