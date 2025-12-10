import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "measure", "quantity"]

  // Mapping des formats de médicaments vers les mesures
  // Ordre important : les plus spécifiques en premier
  formatMappings = [
    // Gélules et capsules
    { pattern: "gélule", measure: "Gélule" },
    { pattern: "gelule", measure: "Gélule" },
    { pattern: "capsule", measure: "Capsule" },

    // Comprimés (toutes variantes)
    { pattern: "comprimé", measure: "Comprimé" },
    { pattern: "comprime", measure: "Comprimé" },

    // Solutions liquides
    { pattern: "sirop", measure: "Cuillère à soupe" },
    { pattern: "solution buvable", measure: "ml" },
    { pattern: "suspension buvable", measure: "ml" },
    { pattern: "gouttes", measure: "Gouttes" },

    // Injectables
    { pattern: "solution injectable", measure: "Injection" },
    { pattern: "injectable", measure: "Injection" },

    // Solution générique
    { pattern: "solution", measure: "ml" },

    // Autres formes
    { pattern: "système de diffusion", measure: "Patch" },
    { pattern: "patch", measure: "Patch" },
    { pattern: "sachet", measure: "Sachet" },
    { pattern: "ampoule", measure: "Ampoule" }
  ]

  // Options de quantité par type de mesure
  quantityOptions = {
    default: [1, 2, 3, 4, 5],
    ml: [5, 10, 15, 20, 25, 50, 100],
    gouttes: [1, 2, 3, 4, 5, 10, 15, 20]
  }

  updateMeasure() {
    const selectedOption = this.selectTarget.selectedOptions[0]
    if (!selectedOption) return

    const format = selectedOption.dataset.format
    if (!format) return

    const formatLower = format.toLowerCase()

    for (const mapping of this.formatMappings) {
      if (formatLower.includes(mapping.pattern)) {
        this.measureTarget.value = mapping.measure
        this.updateQuantityOptions()
        return
      }
    }
  }

  updateQuantityOptions() {
    console.log("updateQuantityOptions appelé")

    if (!this.hasQuantityTarget) {
      console.log("Pas de quantityTarget")
      return
    }

    const measure = this.measureTarget.value.toLowerCase()
    console.log("Mesure sélectionnée:", measure)

    let options = this.quantityOptions.default

    if (measure === "ml") {
      options = this.quantityOptions.ml
    } else if (measure === "gouttes") {
      options = this.quantityOptions.gouttes
    }

    console.log("Options:", options)

    const currentValue = this.quantityTarget.value
    this.quantityTarget.innerHTML = ""

    options.forEach(opt => {
      const option = document.createElement("option")
      option.value = opt
      option.textContent = opt
      if (opt.toString() === currentValue) {
        option.selected = true
      }
      this.quantityTarget.appendChild(option)
    })
  }
}
