import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectAll", "day"]

  connect() {
    this.updateSelectAll()
  }

  toggleAll() {
    const isChecked = this.selectAllTarget.checked
    this.dayTargets.forEach(checkbox => {
      checkbox.checked = isChecked
    })
  }

  updateSelectAll() {
    const allChecked = this.dayTargets.every(checkbox => checkbox.checked)
    const someChecked = this.dayTargets.some(checkbox => checkbox.checked)

    this.selectAllTarget.checked = allChecked
    this.selectAllTarget.indeterminate = someChecked && !allChecked
  }
}
