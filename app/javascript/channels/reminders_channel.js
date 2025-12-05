import { consumer } from "solid_cable"

const userId = document.body.dataset.currentUserId

if (userId) {
  consumer.subscriptions.create(
    { channel: `reminders_${userId}` },
    {
      received(data) {
        const container = document.getElementById("reminder-alerts")
        if (container) {
          container.insertAdjacentHTML("beforeend", data.alert)
        }
      }
    }
  )
}
