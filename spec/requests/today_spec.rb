require 'rails_helper'

RSpec.describe "Todays", type: :request do



  describe "GET /today" do
    subject { get today_path }

    context "With existing season" do
      let!(:season) { create(:season) }

      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    context "When no season even exists" do
      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end
  end

end
