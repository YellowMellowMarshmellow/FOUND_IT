import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="match-slider"
export default class extends Controller {
  static targets = ["card"]

  connect() {
    console.log("MatchSliderController connected")
    this.currentIndex = 0
  }

  nextCard() {
    if (this.currentIndex < this.cardTargets.length) {
      this.cardTargets[this.currentIndex].classList.add("hidden")
      this.currentIndex++
      if (this.currentIndex < this.cardTargets.length) {
        this.cardTargets[this.currentIndex].classList.remove("hidden")
      } else {
        alert("No more matches!")
      }
    }
  }
}
