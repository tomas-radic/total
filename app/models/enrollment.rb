class Enrollment < ApplicationRecord

  # Relations -----
  belongs_to :player
  belongs_to :season


  # Validations -----
  validates :player_id, uniqueness: { scope: :season_id }


  # Scopes -----
  scope :active, -> { where(canceled_at: nil) }


  def avg_matches_monthly
    return @avg_matches_monthly unless @avg_matches_monthly.nil?

    month_beginning = created_at.to_date.beginning_of_day
    month_end = month_beginning + 1.month
    end_of_time = Time.now
    end_of_time = season.ended_at if season.ended_at && season.ended_at < end_of_time

    matches = player.matches.reviewed.where(competitable: season)
    matches_counts = []

    while month_end <= end_of_time
      matches_to_count = matches.where("reviewed_at >= ? and reviewed_at < ?", month_beginning, month_end)
      matches_counts << matches_to_count.count
      month_beginning += 1.month
      month_end += 1.month
    end

    if matches_counts.any?
      @avg_matches_monthly = matches_counts.inject(0) { |sum, c| sum += c } / matches_counts.length
    end
  end
end
