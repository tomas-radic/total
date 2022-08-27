class Manager::ArticlesController < Manager::BaseController

  before_action :ensure_managed_season

  def index
    @articles = @managed_season.articles.order(created_at: :desc)
  end


  def new
    @heading = "Nový článok"
    @article = @managed_season.articles.new
  end


  def create
    @article = @managed_season.articles.new({ manager_id: current_manager.id }.merge(whitelisted_params))

    if @article.save
      redirect_to manager_articles_path
    else
      @heading = @article.title.presence || "Nový článok"
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @article = @managed_season.articles.find(params[:id])
    @heading = @article.title
  end


  def update
    @article = @managed_season.articles.find(params[:id])

    if @article.update(whitelisted_params)
      redirect_to manager_articles_path
    else
      @heading = params[:heading]
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @article = @managed_season.articles.find(params[:id])

    if @article.destroy
      redirect_to manager_articles_path
    else
      @heading = @article.title
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def whitelisted_params
    params.require(:article).permit(:title, :content, :link, :promote_until, :color_base,
                                    :published_at, :comments_disabled_since)
  end

end
