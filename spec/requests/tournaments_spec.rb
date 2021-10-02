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

    let!(:tournament) { create(:tournament, :published) }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end

end
