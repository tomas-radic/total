require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /about" do
    subject { get about_path }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end
end
