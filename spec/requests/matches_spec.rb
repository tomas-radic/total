require 'rails_helper'

RSpec.describe "Matches", type: :request do

  let!(:season) { create(:season) }

  describe "GET /matches" do
    subject { get matches_path }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end

end
