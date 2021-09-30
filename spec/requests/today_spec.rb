require 'rails_helper'

RSpec.describe "Todays", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/today/index"
      expect(response).to have_http_status(:success)
    end
  end

end
