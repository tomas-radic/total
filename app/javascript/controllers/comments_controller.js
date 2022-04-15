import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "replyControl" ]

  connect() {

  }


  setReply() {
    document.getElementById("reply-control").classList.remove("d-none")
    document.getElementById("comment_content").focus()
    document.getElementById("comment_motive_id").value = event.currentTarget.dataset.commentId
    document.getElementById("motive-position").textContent = event.currentTarget.dataset.commentPosition
  }


  cancelReply() {
    document.getElementById("comment_motive_id").value = null
    document.getElementById("motive-position").textContent = ""
    document.getElementById("reply-control").classList.add("d-none")
    document.getElementById("comment_content").focus()
  }
}
