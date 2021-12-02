require 'rails_helper'

RSpec.describe "Matches", type: :request do

  describe "GET /matches" do
    subject { get matches_path }

    context "With existing season" do
      let!(:season) { create(:season) }

      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    context "Without any seasons existing" do
      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end
  end


  describe "GET /matches/:id" do
    subject { get match_path(match) }

    let!(:match) { create(:match, :reviewed) }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end

end
