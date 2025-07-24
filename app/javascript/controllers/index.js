// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
//import AddressAutocompleteController from "./address_autocomplete_controller.js"
//Stimulus.register("address-autocomplete", AddressAutocompleteController)
