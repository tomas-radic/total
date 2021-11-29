require 'rails_helper'

RSpec.describe "Players", type: :request do

  let!(:season) { create(:season) }

  describe "GET /player/:id" do
    subject { get player_path(player) }

    let!(:player) { create(:player) }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end

end
