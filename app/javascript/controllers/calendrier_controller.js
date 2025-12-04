import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["day", "panel"]

  select(event) {
    const day = event.currentTarget

    document.querySelectorAll('[data-calendrier-target="panel"]').forEach(panel => {
      panel.innerHTML = ""
    })

    // Quel index pour ce jour ?
    const index = this.dayTargets.indexOf(day)
    if (index === -1) return

    // Panel qui correspond au même index
    const panel = this.panelTargets[index]
    if (!panel) return

    this.#markActiveDay(day)
    this.#renderPanel(panel)
  }

  #markActiveDay(selectedDay) {
    this.dayTargets.forEach((day) => day.classList.remove("selected-day"))
    selectedDay.classList.add("selected-day")
  }

  #renderPanel(panel) {
    panel.innerHTML = `
      <div class="rounded-2xl shadow p-3 bg-white">
        <p style="font-size:0.85rem; color:#4b5563;">
          Ici tu pourras afficher les éléments de cette journée.
        </p>
      </div>
    `
  }
}
