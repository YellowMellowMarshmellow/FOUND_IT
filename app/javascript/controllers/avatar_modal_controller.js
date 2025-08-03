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
    this.avatarTargets.forEach(img =>
      img.classList.remove("border-primary", "border-3", "selected")
    )

    avatar.classList.add("border-primary", "border-3", "selected")
    const url = avatar.dataset.avatarUrl || avatar.src
    const filename = url.split("/").pop()
    const cleanedFilename = filename.replace(/(_|-)[0-9a-f]{32,}\.jpg$/, '.jpg')

    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = cleanedFilename
    }

    if (this.hasPreviewTarget) {
      this.previewTarget.src = avatar.src
    }

    this.selectedAvatar = cleanedFilename
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
