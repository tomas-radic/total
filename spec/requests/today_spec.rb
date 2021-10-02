require 'rails_helper'

RSpec.describe "Todays", type: :request do
  describe "GET /today" do
    subject { get today_path }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end

end
