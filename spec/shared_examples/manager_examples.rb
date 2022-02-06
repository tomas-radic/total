shared_examples "manager_request" do |parameter|

  context "When manager is signed in but has access denied" do

    # before do
    #   sign_in manager
    #   manager.update_column :access_denied_since, 1.minute.ago
    # end
    #
    # it "Signs out manager and redirects" do
    #   subject
    #
    #   expect(controller.current_manager).to be_nil
    #   expect(response).to redirect_to root_path
    # end

  end

  context "When manager is signed out" do

    before do
      sign_out manager
      manager.update_column :access_denied_since, nil
    end

    it "Redirects to sign in path" do
      subject

      expect(response).to redirect_to new_manager_session_path
    end

  end
end
