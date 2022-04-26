import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
      "loadTime"
  ]

  connect() {
    this.loadTimeTarget.textContent = Math.floor(Date.now() / 1000)

    window.addEventListener("focus", this.autoreload);
  }


  autoreload() {
    var now = Math.floor(Date.now() / 1000)
    var loadTime = parseInt(document.querySelectorAll('[data-application-target="loadTime"]')[0].textContent)

    if ((now - loadTime) > 10800) { // if > 3 hours
      location.reload()
    }
  }
}
