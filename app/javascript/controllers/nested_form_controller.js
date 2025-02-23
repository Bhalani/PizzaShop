import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "target"]

  add(event) {
    console.log("asdfsdfsadf")
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD_INDEX/g, new Date().getTime())
    this.targetTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields")
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = "1"
      wrapper.style.display = "none"
    }
  }
}
