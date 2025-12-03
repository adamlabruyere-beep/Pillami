import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["day", "panel"]

  connect() {
    this.days = this.hasDayTarget ? this.dayTargets : []
    this.panel = this.hasPanelTarget ? this.panelTarget : null
  }

  select(event) {
    if (!this.days.length || !this.panel) return

    const day = event.currentTarget
    const weekday = day.dataset.weekday
    const month = day.dataset.month
    const dayNumber = day.querySelector("p:nth-child(2)")?.textContent || ""

    this.#markActiveDay(day)
    this.#renderPanel({ weekday, month, dayNumber })
  }

  #markActiveDay(selectedDay) {
    this.days.forEach((day) => day.classList.remove("selected-day"))
    selectedDay.classList.add("selected-day")
  }

  #renderPanel({ weekday, month, dayNumber }) {
    this.panel.innerHTML = `
      <div class="border rounded-2xl shadow p-4 bg-white">
        <h2 style="font-weight:600; margin-bottom:0.5rem; text-align:center;">
          ${weekday} ${dayNumber} ${month}
        </h2>
        <p style="font-size:0.9rem; color:#4b5563;">
          Ici tu pourras afficher les éléments de cette journée
          (médicaments, notes, formulaires, etc.).
        </p>
      </div>
    `
  }
}
