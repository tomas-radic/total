require 'rails_helper'

RSpec.describe "Rankings", type: :request do

  let!(:season) { create(:season) }

  describe "GET /rankings" do
    subject { get rankings_path }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end

end
