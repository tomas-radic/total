require 'rails_helper'

RSpec.describe "Player::Players", type: :request do

  let!(:player) { create(:player, name: "Player", email: "player@somewhere.com") }

  describe "POST /player/players/anonymize" do
    subject { post player_players_anonymize_path, params: params }


    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With matching confirmation email" do
        let(:params) do
          { confirmation_email: player.email }
        end

        it "Anonymizes player's attributes and redirects to root path" do
          expect_any_instance_of(Player).to(receive(:anonymize!))

          expect(subject).to redirect_to(root_path)
        end
      end

      context "With non-matching confirmation email" do
        let(:params) do
          { confirmation_email: "incorrect@somewhere.com" }
        end

        it "Does not anonymize player's attributes and redirects back to profile page" do
          expect_any_instance_of(Player).not_to(receive(:anonymize!))

          expect(subject).to redirect_to(edit_player_registration_path)
        end

      end
    end


    context "When player is NOT logged in" do
      let(:params) do
        { confirmation_email: player.email }
      end

      it "Redirects to login page" do
        expect(subject).to redirect_to new_player_session_path
      end
    end
  end


  describe "POST /player/players/toggle_open_to_play" do
    subject { post player_players_toggle_open_to_play_path }

    context "When player is logged in" do
      before do
        sign_in player
      end

      it "Sets timestamp to open_to_play_since attribute" do
        subject

        expect(player.reload.open_to_play_since).not_to be_nil
      end

      context "When open_to_play_since is already set" do
        before do
          player.update_column(:open_to_play_since, Time.now)
        end

        it "Sets nil to open_to_play_since attribute" do
          subject

          expect(player.reload.open_to_play_since).to be_nil
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
