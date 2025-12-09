import { Controller } from "@hotwired/stimulus"

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
        // Insert turbo stream into DOM - Turbo will automatically process it
        document.body.insertAdjacentHTML("beforeend", html)
      }
    } catch (e) {
      console.error("Polling error:", e)
    }
  }
}
