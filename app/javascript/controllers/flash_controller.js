import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number }

  connect() {
    setTimeout(() => {
      this.element.style.transition = "opacity 0.5s ease"
      this.element.style.opacity = "0"

      setTimeout(() => {
        this.element.remove()
      }, 500)
    }, this.timeoutValue || 4000)
  }
}
