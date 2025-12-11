import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  toggle() {
    const isHidden = this.menuTarget.classList.contains("hidden")
    this.menuTarget.classList.toggle("hidden")

    if (this.hasButtonTarget) {
      if (isHidden) {
        this.buttonTarget.style.backgroundColor = "#e5e7eb"
      } else {
        this.buttonTarget.style.backgroundColor = "#ffffff"
      }
    }
  }
}
