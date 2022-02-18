require 'rails_helper'

RSpec.describe "Tournaments", type: :request do

  describe "GET /tournaments" do
    subject { get tournaments_path }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end


  describe "GET /tournaments/:id" do
    subject { get tournament_path(tournament) }

    context "With published tournament" do
      let!(:tournament) { create(:tournament) }

      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
      end
    end

    context "With NOT published tournament" do
      let!(:tournament) { create(:tournament, published_at: nil) }

      it "Redirects to root" do
        expect(subject).to redirect_to(root_path)
      end
    end
  end

end
