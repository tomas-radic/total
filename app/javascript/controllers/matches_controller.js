import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["finishForm"]

  connect() {

  }


  score_typing() {
    var scoreInputField = this.finishFormTarget.querySelector("#score-input")
    var scorePreviewField = this.finishFormTarget.querySelector("#score-preview")
    var submitButton = this.finishFormTarget.querySelector("input[type='submit']")
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
  }
}
