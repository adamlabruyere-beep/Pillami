// app/javascript/controllers/calendrier_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["day", "panel", "track", "template"]
  static values  = { index: { type: Number, default: 0 } }

  connect() {
    // Positionne le carrousel et affiche les rappels du jour courant
    this.showCurrentSlide()
    this.renderCurrentPanel()
  }

  // ---------- Carrousel ----------

  next() {
    if (this.dayTargets.length === 0) return
    this.indexValue = (this.indexValue + 1) % this.dayTargets.length
    this.showCurrentSlide()
    this.renderCurrentPanel()
  }

  prev() {
    if (this.dayTargets.length === 0) return
    this.indexValue = (this.indexValue - 1 + this.dayTargets.length) % this.dayTargets.length
    this.showCurrentSlide()
    this.renderCurrentPanel()
  }

  showCurrentSlide() {
    if (!this.hasTrackTarget) return
    const offset = -this.indexValue * 100
    this.trackTarget.style.transform = `translateX(${offset}%)`
  }

  // ---------- Swipe tactile ----------

  touchStart(event) {
    if (!event.changedTouches || event.changedTouches.length === 0) return
    this.startX = event.changedTouches[0].clientX
  }

  touchEnd(event) {
    if (this.startX == null || !event.changedTouches || event.changedTouches.length === 0) return

    const endX = event.changedTouches[0].clientX
    const deltaX = endX - this.startX
    const threshold = 40

    if (Math.abs(deltaX) > threshold) {
      if (deltaX < 0) {
        this.next()   // swipe vers la gauche → jour suivant
      } else {
        this.prev()   // swipe vers la droite → jour précédent
      }
    }

    this.startX = null
  }

  // ---------- Clic sur un jour ----------

  select(event) {
    const day   = event.currentTarget
    const index = this.dayTargets.indexOf(day)
    if (index === -1) return

    this.indexValue = index
    this.showCurrentSlide()
    this.renderCurrentPanel()
    this.markActiveDay(day)
  }

  // ---------- Helpers ----------

  renderCurrentPanel() {
    if (!this.hasPanelTarget || this.templateTargets.length === 0) return

    const index    = this.indexValue
    const template = this.templateTargets[index]

    if (!template) {
      // aucun template pour ce jour → on vide le panel
      this.panelTarget.innerHTML = ""
      return
    }

    this.panelTarget.innerHTML = template.innerHTML
  }

  markActiveDay(selectedDay) {
    this.dayTargets.forEach((day) => day.classList.remove("selected-day"))
    selectedDay.classList.add("selected-day")
  }
}
