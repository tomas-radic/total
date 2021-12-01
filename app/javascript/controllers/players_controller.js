import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
      "anonymizeEmail"
  ]

  connect() {

  }


  confirmAnonymize(event) {
    var enableSubmit = (event.target.value === event.target.dataset["confirmationEmail"])
    event.target.parentElement.querySelector("input[type=submit]").disabled = !enableSubmit
  }
}
