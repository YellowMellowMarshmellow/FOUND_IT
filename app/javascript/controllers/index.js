import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import AddressAutocompleteController from "./address_autocomplete_controller.js"
import FlashController from "./flash_controller.js"

const application = Application.start()

// Eager-load other controllers in the folder
eagerLoadControllersFrom("controllers", application)

application.register("address-autocomplete", AddressAutocompleteController)
application.register("flash", FlashController)
