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


  def modal_window(id, trigger_id:, &block)
    content_tag :div,
                id: id,
                class: "fixed z-10 inset-0 overflow-y-auto",
                "aria-labelledby" => "modal-title",
                role: "dialog",
                "aria-modal" => true do

      content_tag :div, class: "flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0" do
        modal_element1 = content_tag :div, id: "#{id}-overlay", class: "fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity", "aria-hidden" => "true" do

        end

        modal_element2 = content_tag :span, class: "hidden sm:inline-block sm:align-middle sm:h-screen", "aria-hidden" => "true" do
          "&#8203;"
        end

        modal_element3 = content_tag :div, class: "inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full" do
          yield
        end

        script_content = <<SCRIPT
document.addEventListener("turbo:load", function() {
  const modal = document.querySelector('##{id}')
  const triggerButton = document.querySelector('##{trigger_id}')

  if (modal && triggerButton) {
    modal.hidden = true
    triggerButton.addEventListener('click', toggleModal)

    const overlay = document.querySelector('##{id}-overlay')
    overlay.addEventListener('click', toggleModal)

    const cancelButton = document.getElementById("#{id}").getElementsByClassName("modal-cancel")[0]
    cancelButton.addEventListener('click', function() { modal.hidden = true })

    function toggleModal () {
      const modal = document.querySelector('##{id}')
      modal.hidden = !modal.hidden
    }
  }
});
SCRIPT

        modal_element1 + modal_element2 + modal_element3 + javascript_tag do
          script_content.html_safe
        end
      end
    end
  end

end
