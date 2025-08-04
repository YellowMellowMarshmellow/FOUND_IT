// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//     static targets = ["avatar", "hiddenInput"]

//     connect() {
//         console.log("AvatarSelector connected (edit mode)")


//         if (this.hiddenInputTarget.value) {
//             this.avatarTargets.forEach(avatar => {
//                 const url = avatar.dataset.avatarUrl || avatar.src.split("/").pop()
//                 if (url === this.hiddenInputTarget.value) {
//                     avatar.classList.add("selected")
//                 }
//             })
//         }
//     }

//     selectAvatar(event) {
//         const selected = event.currentTarget


//         const url = selected.dataset.avatarUrl || selected.src.split("/").pop()
//         this.hiddenInputTarget.value = url


//         this.avatarTargets.forEach(a => a.classList.remove("selected"))
//         selected.classList.add("selected")
//     }
// }
