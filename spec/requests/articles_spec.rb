require 'rails_helper'

RSpec.describe "Articles", type: :request do

  describe "GET /articles" do
    subject { get articles_path }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end


  describe "GET /articles/:id" do
    subject { get article_path(article) }

    context "With published article" do
      let!(:article) { create(:article) }

      it "Returns http success" do
        subject

        expect(response).to have_http_status(:success)
      end
    end

    context "With NOT published article" do
      let!(:article) { create(:article, published_at: nil) }

      it "Redirects to root" do
        expect(subject).to redirect_to(not_found_path)
      end
    end
  end

end
