import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

window.Stimulus = application

export { application }

document.addEventListener("DOMContentLoaded", () => {
    const bell = document.getElementById("notification-bell");
    const dropdown = document.getElementById("notification-dropdown");

    dropdown.style.display = 'none';

    if (bell && dropdown) {
        bell.addEventListener("click", (event) => {
            event.stopPropagation();
            const isOpen = dropdown.style.display === "block";
            dropdown.style.display = isOpen ? "none" : "block";
        });

        document.addEventListener("click", (event) => {
            if (!bell.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.style.display = "none";
            }
        });
    }
});
