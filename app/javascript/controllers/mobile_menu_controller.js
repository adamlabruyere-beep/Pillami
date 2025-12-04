import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nav", "overlay", "openIcon", "closeIcon"]

  toggle() {
    if (this.navTarget.classList.contains("-translate-x-full")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.navTarget.classList.remove("-translate-x-full")
    this.navTarget.classList.add("translate-x-0")
    this.overlayTarget.classList.remove("hidden")
    this.openIconTarget.classList.add("hidden")
    this.closeIconTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.navTarget.classList.add("-translate-x-full")
    this.navTarget.classList.remove("translate-x-0")
    this.overlayTarget.classList.add("hidden")
    this.openIconTarget.classList.remove("hidden")
    this.closeIconTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }
}
