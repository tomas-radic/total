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
    subject { get article_path(":id") }

    it "Returns http success" do
      subject

      expect(response).to have_http_status(:success)
    end
  end

end
