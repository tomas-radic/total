module Player::MatchesHelper

  def link_to_match(match, current_player, &block)
    link_to match_path(match), class: "underline" do
      if block_given?
        yield
      else
        "Detaily"
      end
    end
  end

end
