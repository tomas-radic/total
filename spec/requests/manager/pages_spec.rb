require 'rails_helper'

RSpec.describe "Manager::Pages", type: :request do

  describe "GET /manager/pages/dashboard" do
    subject { get manager_pages_dashboard_path }

    let!(:manager) { create(:manager) }

    context "As a logged in manager" do
      before { sign_in manager }

      it "Renders template" do
        subject

        expect(response).to render_template("dashboard")
        expect(response).to have_http_status(:success)
      end
    end

    context "As a logged in player with the same email" do
      it "Redirects to log in" do

      end
    end

  end

end
