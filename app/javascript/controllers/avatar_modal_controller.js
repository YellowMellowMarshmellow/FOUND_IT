import { Controller } from "@hotwired/stimulus"
// import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = ["modal", "avatar", "hiddenInput", "form"]

  connect() {
    console.log("modalTarget:", this.modalTarget)
    if (!this.modalTarget) {
      console.error("Modal target not found!")
      return
    }
    this.bootstrapModal = new bootstrap.Modal(this.modalTarget)
    this.selectedAvatar = null
  }

  openModal(event) {
    event.preventDefault()
    this.bootstrapModal.show()
  }

  selectAvatar(event) {
    this.avatarTargets.forEach(img =>
      img.classList.remove("border-primary", "border-3")
    )

    const selected = event.currentTarget
    selected.classList.add("border-primary", "border-3")
    this.selectedAvatar = selected.dataset.avatarUrl
  }

  confirm() {
    if (this.selectedAvatar) {
      const filename = this.selectedAvatar.split("/").pop()

      const cleanedFilename = filename.replace(/(_|-)[0-9a-f]{32,}\.jpg$/, '.jpg')
      this.hiddenInputTarget.value = cleanedFilename

      this.formTarget.submit()
    } else {
      alert("Please select an avatar.")
    }
  }
}
