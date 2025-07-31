import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["textarea"];

    insertBadge(event) {
        event.preventDefault();
        const badgeText = event.currentTarget.dataset.badgeText;
        const textarea = this.textareaTarget;

        if (!textarea) return;

        textarea.value = (textarea.value + (textarea.value ? " " : "") + badgeText).trim();
        textarea.focus();
    }
}