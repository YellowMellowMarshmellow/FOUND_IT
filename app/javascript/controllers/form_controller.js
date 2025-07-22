import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static values = { formType: String }

  connect() {
    this.imageContainer = document.getElementById("image-fields")
    this.addButton = document.getElementById("add-image-field")
    this.formElement = this.element

    if (this.imageContainer && this.addButton) {
      this.addButton.addEventListener("click", this.addImageField.bind(this))
      this.formElement.addEventListener("submit", this.validateBeforeSubmit.bind(this))
    }
  }

  addImageField() {
    const existingInputs = this.imageContainer.querySelectorAll("input[type='file']")
    if (existingInputs.length < 3) {
      const newInput = document.createElement("input")
      newInput.type = "file"
      newInput.name = `${this.formElement.getAttribute("name") || 'item'}[images][]`
      newInput.className = "form-control mb-2"
      this.imageContainer.appendChild(newInput)
    } else {
      alert("You can only upload up to 3 images.")
    }
  }

  validateBeforeSubmit(event) {
    const fileInputs = this.imageContainer.querySelectorAll("input[type='file']")
    const filledInputs = Array.from(fileInputs).filter(input => input.files.length > 0)

    const isFoundForm = this.formTypeValue === "found"

    if (isFoundForm && filledInputs.length < 1) {
      event.preventDefault()
      alert("You must upload at least 1 image for a found item.")
    }

    if (filledInputs.length > 3) {
      event.preventDefault()
      alert("You can only upload up to 3 images.")
    }
  }
}
