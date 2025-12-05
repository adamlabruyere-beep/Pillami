import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["day", "panel", "track"]
  static values = { index: { type: Number, default: 0 } }

connect() {
    this.showCurrentSlide()
  }

  // --- Carrousel ---

  next() {
    if (this.dayTargets.length === 0) return
    this.indexValue = (this.indexValue + 1) % this.dayTargets.length
    this.showCurrentSlide()
  }

  prev() {
    if (this.dayTargets.length === 0) return
    this.indexValue = (this.indexValue - 1 + this.dayTargets.length) % this.dayTargets.length
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    if (!this.hasTrackTarget) return
    const offset = -this.indexValue * 100
    this.trackTarget.style.transform = `translateX(${offset}%)`
  }

  // --- Swipe tactile ---

  touchStart(event) {
    if (!event.changedTouches || event.changedTouches.length === 0) return
    this.startX = event.changedTouches[0].clientX
  }

  touchEnd(event) {
    if (this.startX === null || !event.changedTouches || event.changedTouches.length === 0) return

    const endX = event.changedTouches[0].clientX
    const deltaX = endX - this.startX
    const threshold = 40 // px à dépasser pour déclencher

    if (Math.abs(deltaX) > threshold) {
      if (deltaX < 0) {
        this.next()  // swipe gauche => jour suivant
      } else {
        this.prev()  // swipe droite => jour précédent
      }
    }

    this.startX = null
  }

  // --- Click sur un jour ---

  select(event) {
    const day = event.currentTarget

    // régler l’index du carrousel sur ce jour
    const index = this.dayTargets.indexOf(day)
    if (index !== -1) {
      this.indexValue = index
      this.showCurrentSlide()
    }

    if (this.openIndex === index) {
      // → On ferme le panel si on reclique sur le même jour
      this.#closeAllPanels()
      this.openIndex = null
      return
    }

    // vider tous les panels
    this.panelTargets.forEach((panel) => { panel.innerHTML = "" })

    // panel associé au jour cliqué (même index)
    this.#closeAllPanels()
    const panel = this.panelTargets[index]
    if (!panel) return

    this.#markActiveDay(day)
    this.#renderPanel(panel, day)
    this.openIndex = index
  }

  #closeAllPanels() {
    this.panelTargets.forEach(p => p.innerHTML = "")
    this.dayTargets.forEach(d => d.classList.remove("selected-day"))
  }

  #markActiveDay(selectedDay) {
    this.dayTargets.forEach((day) => day.classList.remove("selected-day"))
    selectedDay.classList.add("selected-day")
  }

  #renderPanel(panel) {

    panel.innerHTML = `
      <div class="rounded-2xl shadow p-3 bg-white">
        <p class="text-xs text-gray-600">
          Ici tu pourras afficher les éléments de cette journée.
        </p>
      </div>
    `
  }
}
