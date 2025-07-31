import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.maxImages = 3;
  }

  addField() {
    const existingInputs = this.containerTarget.querySelectorAll("input[type='file']");
    if (existingInputs.length < this.maxImages) {
      const newInput = document.createElement("input");
      newInput.type = "file";
      newInput.name = "found_item[images][]";
      newInput.className = "form-control mb-2";
      this.containerTarget.appendChild(newInput);
    } else {
      alert(`You can only upload up to ${this.maxImages} images.`);
    }
  }
}
