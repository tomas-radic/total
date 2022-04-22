class ArticlesController < ApplicationController

  def index
    if selected_season.present?
      @articles = selected_season.articles.published.sorted
    end
  end


  def show
    @article = selected_season.articles.published.find(params[:id])
  end

end
