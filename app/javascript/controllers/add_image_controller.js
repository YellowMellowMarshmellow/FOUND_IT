import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="add-image"
export default class extends Controller {
  static targets = ["container", "button"];
  static values = {
    existingCount: Number,
    max: { type: Number, default: 3 }
  };

  connect() {
    this.updateButtonState();
  }

  addField() {
    const newInput = document.createElement("input");
    newInput.type = "file";
    newInput.name = "found_item[images][]";
    newInput.className = "form-control mb-2";

    this.containerTarget.appendChild(newInput);
    this.updateButtonState();
  }

  updateButtonState() {
    const newInputs = this.containerTarget.querySelectorAll("input[type='file']");
    const total = this.existingCountValue + newInputs.length;

    if (total >= this.maxValue) {
      this.buttonTarget.disabled = true;
    } else {
      this.buttonTarget.disabled = false;
    }
  }

  decrementCount() {
    this.existingCountValue = this.existingCountValue - 1;
    this.updateButtonState();
  }

}
