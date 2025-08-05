import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["modal", "avatar", "hiddenInput", "form", "preview"]

  connect() {
    console.log("AvatarSelector connected!")

    if (this.hasModalTarget) {
      this.bootstrapModal = new bootstrap.Modal(this.modalTarget)
      this.selectedAvatar = null
    }

    // Activer la sélection dès la connexion (utile pour edit)
    this.avatarTargets.forEach(avatar => {
      avatar.addEventListener("click", () => {
        this.selectAvatarDirectly(avatar)
      })
    })

    // Pré-sélection en mode édition
    if (this.hasHiddenInputTarget && this.hiddenInputTarget.value) {
      this.avatarTargets.forEach(a => {
        if ((a.dataset.avatarUrl || a.src.split("/").pop()) === this.hiddenInputTarget.value) {
          a.classList.add("selected")
        }
      })
    }
  }

  openModal(event) {
    event.preventDefault()

    if (this.bootstrapModal) {
      this.bootstrapModal.show()
    }
  }

  selectAvatar(event) {
    const selected = event.currentTarget
    this.selectAvatarDirectly(selected)
  }

  selectAvatarDirectly(avatar) {
  // Clear selection from all avatar images
  this.avatarTargets.forEach(img =>
    img.classList.remove("border-primary", "border-3", "selected")
  )

  // Highlight the selected one
  avatar.classList.add("border-primary", "border-3", "selected")

  // Use full Cloudinary URL from data-avatar-url (preferred), fallback to src
  const fullUrl = avatar.dataset.avatarUrl || avatar.src

  // Save full URL to hidden input and preview
  if (this.hasHiddenInputTarget) {
    this.hiddenInputTarget.value = fullUrl
  }

  if (this.hasPreviewTarget) {
    this.previewTarget.src = fullUrl
  }

  // Save selected value internally for confirm()
  this.selectedAvatar = fullUrl
}

  confirm() {
  if (this.selectedAvatar) {
    this.hiddenInputTarget.value = this.selectedAvatar
    this.formTarget.submit()
    } else {
      alert("Please select an avatar.")
    }
  }
}
