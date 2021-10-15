require 'rails_helper'

RSpec.describe "Player::Matches", type: :request do

  let!(:season) { create(:season, ended_at: nil) }

  describe "POST /player/matches" do
    subject { post player_matches_path, params: { player_id: requested_player.id } }

    let!(:player) { create(:player, seasons: [season]) }
    let!(:requested_player) { create(:player, seasons: [season]) }

    context "When player is logged in" do

      before do
        sign_in player
      end

      it "Creates new match and redirects" do
        expect { subject }.to change { Match.count }.by(1)

        expect(response).to redirect_to(player_path(requested_player))
      end
    end


    context "When player is NOT logged in" do

      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end


  describe "GET /player/matches/:id" do
    subject { edit_player_match_path(match) }

    let!(:match) { create(:match) }

    # ...
  end


  describe "PUT /player/matches/:id" do
    subject { player_match_path(match) }

    let!(:match) { create(:match) }

    # ...
  end
end
