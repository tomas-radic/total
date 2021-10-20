module MatchesHelper

  def match_color_base(match)
    if match.finished_at && match.reviewed_at
      "base-green"
    elsif !match.rejected_at
      "base-yellow"
    end
  end

end
