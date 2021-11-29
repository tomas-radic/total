import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["finish_form"]

  connect() {

  }


  score_typing() {
    this.finish_formTargets.forEach((element, index) => {

      var scoreInputField = element.querySelector("#score-input")
      var scorePreviewField = element.querySelector("#score-preview")
      var submitButton = element.querySelector("input[type='submit']")
      var scoreValues = scoreInputField.value.trim().split(/\s+/)
      var scorePreviewValue = ""

      scoreValues.forEach((e, idx) => {
        if ((idx % 2) === 1) {
          scorePreviewValue += (":" + e)
        } else if (idx === 0) {
          scorePreviewValue += e
        } else {
          scorePreviewValue += (", " + e)
        }
      });

      scorePreviewField.textContent = scorePreviewValue
      submitButton.disabled = (scoreValues.length % 2) === 1
    });
  }
}
