class Manager::TournamentsController < Manager::BaseController

  before_action :ensure_managed_season

  def index
    @tournaments = @managed_season.tournaments.order(begin_date: :desc)
  end


  def new
    @heading = "Nový turnaj"
    @tournament = @managed_season.tournaments.new
  end


  def create
    @tournament = @managed_season.tournaments.new(whitelisted_params)

    if @tournament.save
      redirect_to manager_tournaments_path
    else
      @heading = @tournament.name.presence || "Nový turnaj"
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @tournament = @managed_season.tournaments.find(params[:id])
    @heading = @tournament.name
  end


  def update
    @tournament = @managed_season.tournaments.find(params[:id])

    if @tournament.update(whitelisted_params)
      redirect_to manager_tournaments_path
    else
      @heading = params[:heading]
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def whitelisted_params
    params.require(:tournament).permit(:name, :begin_date, :end_date, :main_info, :side_info, :color_base,
                                       :published_at, :place_id, :comments_disabled_since,
                                       :draw_url, :schedule_url)
  end

end
