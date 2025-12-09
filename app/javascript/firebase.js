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
};

const vapidKey = "BF-owBQuuFDvTxRRls1teK5qAt-03exK5hWgYy2xMekEuW-zSBN940Nx762EgZL2Kxjzi2NjKoHm9N5jLCJpxiY"

const app = initializeApp(firebaseConfig)
const messaging = getMessaging(app)

export async function registerPushToken() {
  try {

    const registration = await navigator.serviceWorker.register("/firebase-messaging-sw.js")

    const permission = await Notification.requestPermission()
    if (permission !== "granted") return

    const token = await getToken(messaging, { vapidKey })
    if (!token) return

    // Envoie du token à Rails
    await fetch("/device_tokens", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        token: token,
        platform: "web"
      })
    })
  } catch (e) {
    console.error("Erreur FCM", e)
  }
}

if ("serviceWorker" in navigator) {
  navigator.serviceWorker
    .register("/firebase-messaging-sw.js")
    .then((registration) => {
      console.log("✅ Service Worker enregistré :", registration)
    })
    .catch((err) => {
      console.error("❌ Erreur Service Worker :", err)
    })
}
