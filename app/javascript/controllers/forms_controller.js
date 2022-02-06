import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
      "lockableField", "locker", "hideToggler", "hideToggleable"
  ]

  connect() {

  }


  toggleLockFields() {
    this.lockableFieldTargets.forEach((e, idx) => {
      e.disabled = !this.lockerTarget.checked
    })
  }


  toggleHidden() {
    var hideToggleable = this.hideTogglerTarget.closest(".hide-toggler-wrapper")
        .querySelector(".hide-toggleable")

    if (this.hideTogglerTarget.checked) {
      hideToggleable.classList.remove("hidden")
    } else {
      hideToggleable.classList.add("hidden")
    }
  }
}
