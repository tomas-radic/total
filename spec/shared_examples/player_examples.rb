shared_examples "player_request" do |parameter|

  context "When player is signed in but has access denied" do

    before do
      sign_in player
      player.update_column :access_denied_since, 1.minute.ago
    end

    it "Redirects to root path" do
      subject

      expect(response).to redirect_to root_path
    end

    xit "Signs out player and redirects" do
      subject

      expect(controller.current_player).to be_nil
      expect(response).to redirect_to root_path
    end

  end


  context "When player is signed in but is anonymized" do

    before do
      sign_in player
      player.update_column :anonymized_at, 1.minute.ago
    end

    it "Redirects to root path" do
      subject

      expect(response).to redirect_to root_path
    end

    xit "Signs out player and redirects" do
      subject

      expect(controller.current_player).to be_nil
      expect(response).to redirect_to root_path
    end

  end


  context "When player is signed out" do

    before do
      sign_out player
      player.update_column :access_denied_since, nil
    end

    it "Redirects to sign in path" do
      subject

      expect(response).to redirect_to new_player_session_path
    end

  end
end
