import { Controller } from "@hotwired/stimulus"
import * as Turbo from "@hotwired/turbo"

export default class extends Controller {
  static values = {
    interval: { type: Number, default: 30000 },
    url: String
  }

  connect() {
    if (this.hasUrlValue) {
      this.startPolling()
    }
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.timer = setInterval(() => this.poll(), this.intervalValue)
  }

  stopPolling() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  async poll() {
    try {
      const response = await fetch(this.urlValue, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html"
        }
      })
      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (e) {
      // Silently fail on polling errors
    }
  }
}
