import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import AddressAutocompleteController from "./address_autocomplete_controller.js"
import FlashController from "./flash_controller.js"
import MapController from "./map_controller.js"
import AvatarModalController from "./avatar_modal_controller"


const application = Application.start()

// Eager-load other controllers in the folder
eagerLoadControllersFrom("controllers", application)

application.register("address-autocomplete", AddressAutocompleteController)
application.register("flash", FlashController)
application.register("map", MapController)
application.register("avatar-modal", AvatarModalController)
