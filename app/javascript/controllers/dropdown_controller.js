import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.overlay = null
  }

  disconnect() {
    this.removeOverlay()
  }

  toggle() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.highlightButton(true)
    this.addOverlay()
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.highlightButton(false)
    this.removeOverlay()
  }

  highlightButton(active) {
    if (!this.hasButtonTarget) return
    this.buttonTarget.style.backgroundColor = active ? "#e5e7eb" : "#ffffff"
  }

  addOverlay() {
    if (this.overlay) return

    this.overlay = document.createElement("div")
    this.overlay.className = "fixed inset-0 bg-black/40 z-40"
    this.overlay.addEventListener("click", () => this.close())
    document.body.appendChild(this.overlay)
  }

  removeOverlay() {
    if (!this.overlay) return
    this.overlay.remove()
    this.overlay = null
  }
}
