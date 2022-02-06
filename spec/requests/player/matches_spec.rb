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

      it "Creates new match, authorizes it and redirects" do
        expect_any_instance_of(MatchPolicy).to(receive(:create?).and_return(true))
        expect { subject }.to change { Match.count }.by(1)
        expect(response).to redirect_to(player_path(requested_player))
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

      it "Authorizes match and renders edit" do
        expect_any_instance_of(MatchPolicy).to(receive(:edit?).and_return(true))
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

      it "Authorizes the match, updates only whitelisted attributes and redirects" do
        allow_any_instance_of(MatchPolicy).to(receive(:finish?).and_return(true))
        allow_any_instance_of(MatchPolicy).to(receive(:finish?).and_return(true)) # when broadcasting update
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

      it "Authorizes the match, accepts it and cancels open_to_play_since flag of both players" do
        expect_any_instance_of(MatchPolicy).to(receive(:accept?).and_return(true))
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

      it "Authorizes the match, rejects it and preserves open_to_play_since flag of both players" do
        expect_any_instance_of(MatchPolicy).to(receive(:reject?).and_return(true))
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

      context "When call to 'finish' method returns finished match" do

        it "Authorizes the match, calls match.finish and redirects to the match page" do
          expect_any_instance_of(MatchPolicy).to(receive(:finish?).and_return(true))
          expect_any_instance_of(Match).to(
            receive(:finish).and_return(double("match", finished_at: Time.now)))

          subject

          expect(response).to redirect_to match_path(match)
        end

      end

      context "When call to 'finish' method returns unfinished match" do
        before do
          expect_any_instance_of(Match).to(
            receive(:finish).and_return(match))
        end

        it "Authorizes the match and renders finish_init" do
          expect_any_instance_of(MatchPolicy).to(receive(:finish?).and_return(true))
          subject

          expect(response).to render_template(:finish_init)
        end
      end
    end
  end
end
