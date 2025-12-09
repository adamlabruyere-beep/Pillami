// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { registerPushToken } from "firebase"

document.addEventListener("turbo:load", () => {
  if (window.currentUserLoggedIn) { // tu peux exposer ça via un helper
    registerPushToken()
  }
})
// import "./channels/reminders_channel"
