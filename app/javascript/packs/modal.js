document.addEventListener("turbo:load", function() {

  const modalTriggerButtons = document.querySelector(".modal-trigger-button")

  if (modalTriggerButtons !== null) {
    modalTriggerButtons.addEventListener("click", function() {
      let modalName = this.id.slice("modal-trigger-".length)
      let modalWindow = document.querySelector("#modal-window-" + modalName)
      modalWindow.classList.remove("hidden")
      // debugger
    });
  }


  document.addEventListener("keyup", function(e) {
    if (e.key === "Escape") {
      document.querySelector(".modal-window").classList.add("hidden")
    }
  });


  const modalCancelButtons = document.querySelector(".modal-cancel-button")

  if (modalCancelButtons !== null) {
    modalCancelButtons.addEventListener("click", function() {
      let modalName = this.id.slice("modal-cancel-".length)
      let modalWindow = document.querySelector("#modal-window-" + modalName)
      modalWindow.classList.add("hidden")
      // debugger
    });
  }

  const modalOverlays = document.querySelector(".modal-overlay")

  if (modalOverlays !== null) {
    modalOverlays.addEventListener("click", function() {
      let modalName = this.id.slice("modal-overlay-".length)
      let modalWindow = document.querySelector("#modal-window-" + modalName)
      modalWindow.classList.add("hidden")
      // debugger
    });
  }
});
