import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "text", "expandIcon", "collapseIcon"]

  connect() {
    this.collapse()
  }

  toggle() {
    if (this.sidebarTarget.classList.contains("w-16")) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  collapse() {
    // Sidebar width
    this.sidebarTarget.classList.remove("w-64")
    this.sidebarTarget.classList.add("w-16")

    // Hide text elements
    this.textTargets.forEach(el => el.classList.add("hidden"))

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
    this.textTargets.forEach(el => el.classList.remove("hidden"))

    // Toggle button icons
    this.collapseIconTargets.forEach(el => el.classList.remove("hidden"))
    this.expandIconTargets.forEach(el => el.classList.add("hidden"))

    localStorage.setItem("sidebarCollapsed", "false")
  }
}
