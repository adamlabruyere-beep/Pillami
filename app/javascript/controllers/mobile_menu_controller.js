import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nav", "overlay", "openIcon", "closeIcon", "logo", "logoPlaceholder"]

  connect() {
    this.beforeCache = this.close.bind(this)
    document.addEventListener("turbo:before-cache", this.beforeCache)
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.beforeCache)
  }

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

    // Animation du logo: disparaît du header
    if (this.hasLogoTarget) {
      this.logoTarget.classList.add("opacity-0", "-translate-y-2")
    }

    // Animation du logo: apparaît dans la navbar
    if (this.hasLogoPlaceholderTarget) {
      setTimeout(() => {
        this.logoPlaceholderTarget.classList.remove("opacity-0", "-translate-y-4")
        this.logoPlaceholderTarget.classList.add("opacity-100", "translate-y-0")
      }, 150)
    }
  }

  close() {
    this.navTarget.classList.add("-translate-x-full")
    this.navTarget.classList.remove("translate-x-0")
    this.overlayTarget.classList.add("hidden")
    this.openIconTarget.classList.remove("hidden")
    this.closeIconTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")

    // Animation du logo: réapparaît dans le header
    if (this.hasLogoTarget) {
      this.logoTarget.classList.remove("opacity-0", "-translate-y-2")
    }

    // Animation du logo: disparaît de la navbar
    if (this.hasLogoPlaceholderTarget) {
      this.logoPlaceholderTarget.classList.add("opacity-0", "-translate-y-4")
      this.logoPlaceholderTarget.classList.remove("opacity-100", "translate-y-0")
    }
  }
}
