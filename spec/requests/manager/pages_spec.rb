require 'rails_helper'
require 'shared_examples/manager_examples'

RSpec.describe "Manager::Pages", type: :request do

  describe "GET /manager/pages/dashboard" do
    subject { get manager_pages_dashboard_path }

    it_behaves_like "manager_request"

    let!(:manager) { create(:manager) }
    let!(:player) { create(:player, email: manager.email) }

    context "As a logged in manager" do
      before { sign_in manager }

      it "Renders template" do
        subject

        expect(response).to render_template("dashboard")
        expect(response).to have_http_status(:success)
      end
    end

  end

end
