import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "text", "expandIcon", "collapseIcon", "avatar"]

  connect() {
    if (this.isMobile()) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  isMobile() {
    return window.innerWidth < 768
  }

  toggle() {
    if (this.sidebarTarget.classList.contains("w-16")) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  collapse() {
    if (this.isMobile()) return

    // Sidebar width
    this.sidebarTarget.classList.remove("w-64")
    this.sidebarTarget.classList.add("w-16")

    // Hide text elements
    this.textTargets.forEach(el => {
      el.classList.add("hidden")
      el.classList.add("invisible")
    })

    // Hide avatar
    if (this.hasAvatarTarget) {
      this.avatarTarget.classList.add("hidden")
    }

    // Toggle button icons
    this.collapseIconTargets.forEach(el => el.classList.add("hidden"))
    this.expandIconTargets.forEach(el => el.classList.remove("hidden"))

    localStorage.setItem("sidebarCollapsed", "true")
  }

  expand() {
    // Sidebar width
    this.sidebarTarget.classList.remove("w-16")
    this.sidebarTarget.classList.add("w-64")

    // Show text elements
    this.textTargets.forEach(el => {
      el.classList.remove("hidden")
      el.classList.remove("invisible")
    })

    // Show avatar
    if (this.hasAvatarTarget) {
      this.avatarTarget.classList.remove("hidden")
    }

    // Toggle button icons
    this.collapseIconTargets.forEach(el => el.classList.remove("hidden"))
    this.expandIconTargets.forEach(el => el.classList.add("hidden"))

    localStorage.setItem("sidebarCollapsed", "false")
  }
}
