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
    # datetime = datetime.to_date
    # today = Time.zone.now.to_date
    # day_diff = (today - datetime).to_i
    #
    # prefix = case day_diff
    #          when 2
    #            "predvčerom"
    #          when 1
    #            "včera"
    #          when 0
    #            "dnes"
    #          when -1
    #            "zajtra"
    #          when -2
    #            "pozajtra"
    #          else
    #            ""
    #          end

    days = ["pon", "uto", "str", "štv", "pia", "sob", "ned"]
    months = ["jan", "feb", "mar", "apr", "máj", "jún", "júl", "aug", "sep", "okt", "nov", "dec"]

    # result = prefix
    # result += ", " if result.present?
    # result += "#{days[datetime.wday - 1]}, #{datetime.day}. #{months[datetime.month - 1]}."

    "#{days[datetime.wday - 1]}, #{datetime.day}. #{months[datetime.month - 1]}."
  end


  def app_date_span(datetime)
    content_tag :span, class: "whitespace-nowrap" do
      app_date datetime
    end
  end


  def app_time(datetime)
    "#{app_date(datetime)} - #{datetime.strftime("%k:%M")}"
  end


  def text_success_css(success_count, total_count)
    half = total_count / 2.0

    if success_count > half
      "u-nav-green"
    elsif success_count < half
      "u-red"
    end
  end


  def error_for(attribute, object)
    unless object.errors[attribute].blank?
      content_tag :p, class: "u-red" do
        "Chýbajúci, alebo nesprávny údaj."
      end
    end
  end


  def break_whitespace(text)
    text.gsub(/\s+/, "<br>").html_safe
  end


  def percentage(count, of)
    p = (count.to_f * 100.0) / of.to_f

    if p > 0.0 && p < 1.0
      1
    elsif p > 99.0 && p < 100.0
      99
    else
      p.round
    end
  end

end
