module ApplicationHelper

  def shorten_text(text, max_length = nil)
    max_length ||= 24
    dots = "..." if text.length > max_length
    "#{text[0...max_length]}#{dots}"
  end


  def ranking_row_css(season, position)
    result = ""

    if position > season.play_off_size
      result += "text-gray-400"
      result += " border-yellow-400 border-solid border-t-4" if (position - 1) == season.play_off_size
    end

    result
  end


  def app_date(datetime)
    days = ["pon", "uto", "str", "štv", "pia", "sob", "ned"]
    months = ["jan", "feb", "mar", "apr", "máj", "jún", "júl", "aug", "sep", "okt", "nov", "dec"]

    "#{days[datetime.wday - 1]}, #{datetime.day}. #{months[datetime.month - 1]}."
  end


  def app_date_span(datetime)
    content_tag :span, class: "whitespace-nowrap" do
      app_date datetime
    end
  end

end
