module TournamentsHelper

  def tournament_date_css_class(tournament)
    if tournament.published? && tournament.end_date < Date.today
      "u-grey"
    end
  end

end
