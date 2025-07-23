import "@hotwired/turbo-rails"
import "@popperjs/core"
import "bootstrap"
import Rails from "@rails/ujs"
Rails.start()

import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()

eagerLoadControllersFrom("controllers", application)

window.Stimulus = application
export { application }
