// Import Turbo and Bootstrap
import "@hotwired/turbo-rails"
import "@popperjs/core"
import "bootstrap"
// Import Rails UJS (if you need it, but usually not needed with Turbo)
import Rails from "@rails/ujs"
Rails.start()
// Import and configure Stimulus (only once!)
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
const application = Application.start()
// Load controllers from the controllers directory
eagerLoadControllersFrom("controllers", application)
// Make Stimulus available globally
window.Stimulus = application
// Export the application
export { application }

//import "controllers"

// Notification dropdown functionality
document.addEventListener("turbo:load", () => {
  const bell = document.getElementById("notification-bell");
  const dropdown = document.getElementById("notification-dropdown");

  if (!bell || !dropdown) return;

  dropdown.style.display = 'none';

  // Pour éviter d'attacher plusieurs fois
  bell.onclick = (event) => {
    event.stopPropagation();
    const isOpen = dropdown.style.display === "block";
    dropdown.style.display = isOpen ? "none" : "block";
  };

  document.onclick = (event) => {
    if (!bell.contains(event.target) && !dropdown.contains(event.target)) {
      dropdown.style.display = "none";
    }
  };
});
