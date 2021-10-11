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


  def modal_window(id, trigger_id:, &block)
    content_tag :div, id: id, class: "modal opacity-0 pointer-events-none absolute w-full h-full top-0 left-0 flex items-center justify-center" do
      overlay = content_tag :div, id: "#{id}-overlay", class: "p-2 absolute w-full h-full bg-black opacity-25 top-0 left-0 cursor-pointer" do

      end
      content = content_tag :div, class: "absolute p-4 bg-white rounded-sm shadow-lg flex items-center justify-center text-2xl" do
        yield
      end

      script_content = <<SCRIPT
const button = document.querySelector('##{trigger_id}');
button.addEventListener('click', toggleModal);

const overlay = document.querySelector('##{id}-overlay');
overlay.addEventListener('click', toggleModal);

function toggleModal () {
  const modal = document.querySelector('##{id}')
  modal.classList.toggle('opacity-0')
  modal.classList.toggle('pointer-events-none')
}
SCRIPT

      overlay + content + javascript_tag do
        script_content.html_safe
      end
    end
  end

end
