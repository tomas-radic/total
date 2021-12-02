require 'rails_helper'

RSpec.describe "Rankings", type: :request do

  describe "GET /rankings" do
    subject { get rankings_path }

    context "With existing season" do
      let!(:season) { create(:season) }

      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    context "Without any existing seasons" do
      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end
  end

end
