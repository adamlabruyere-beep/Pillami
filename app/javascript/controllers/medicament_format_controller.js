import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "measure"]

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

  updateMeasure() {
    const selectedOption = this.selectTarget.selectedOptions[0]
    if (!selectedOption) return

    const format = selectedOption.dataset.format
    if (!format) return

    const formatLower = format.toLowerCase()

    for (const mapping of this.formatMappings) {
      if (formatLower.includes(mapping.pattern)) {
        this.measureTarget.value = mapping.measure
        return
      }
    }
  }
}
