import { initializeApp } from "firebase/app"
import { getMessaging, getToken } from "firebase/messaging"

const firebaseConfig = {
  apiKey: "AIzaSyAwpB3lK5tNUgkqvnQWtOL91tP9IfRWDDE",
  authDomain: "pillami-e98ac.firebaseapp.com",
  projectId: "pillami-e98ac",
  storageBucket: "pillami-e98ac.firebasestorage.app",
  messagingSenderId: "583918755836",
  appId: "1:583918755836:web:30cf6f69ebfe7f715b1c79",
  measurementId: "G-6FKSN2SZ8F"
}

const vapidKey = "BF-owBQuuFDvTxRRls1teK5qAt-03exK5hWgYy2xMekEuW-zSBN940Nx762EgZL2Kxjzi2NjKoHm9N5jLCJpxiY"

export async function registerPushToken() {
  try {
    if (!("serviceWorker" in navigator) || !("PushManager" in window)) {
      return
    }

    const permission = await Notification.requestPermission()
    if (permission !== "granted") return

    const registration = await navigator.serviceWorker.ready

    const app = initializeApp(firebaseConfig)
    const messaging = getMessaging(app)

    // Supprimer l'ancienne subscription si elle existe
    const existingSub = await registration.pushManager.getSubscription()
    if (existingSub) {
      await existingSub.unsubscribe()
    }

    const token = await getToken(messaging, {
      vapidKey,
      serviceWorkerRegistration: registration
    })

    if (!token) return

    await fetch("/device_tokens", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ token, platform: "web" })
    })
  } catch (e) {
    console.error("Erreur FCM:", e)
  }
}

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/firebase-messaging-sw.js")
}
