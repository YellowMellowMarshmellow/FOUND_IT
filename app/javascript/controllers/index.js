// Import and register all your controllers from the importmap via controllers/**/*_controller
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import AddressAutocompleteController from "./address_autocomplete_controller.js"

const application = Application.start()

// Eager-load other controllers in the folder
eagerLoadControllersFrom("controllers", application)

// Manually register the address autocomplete controller
application.register("address-autocomplete", AddressAutocompleteController)
