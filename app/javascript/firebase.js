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
  console.log("🔔 registerPushToken() appelé")
  try {
    console.log("1. Enregistrement du Service Worker...")
    const registration = await navigator.serviceWorker.register("/firebase-messaging-sw.js")
    console.log("2. Service Worker enregistré")

    // Attendre que le SW soit actif
    if (!registration.active) {
      console.log("2b. Attente activation du SW...")
      await navigator.serviceWorker.ready
      console.log("2c. SW activé")
    }

    console.log("3. Demande de permission...")
    const permission = await Notification.requestPermission()
    console.log("4. Permission:", permission)
    if (permission !== "granted") return

    console.log("5. Récupération du token FCM...")
    const token = await getToken(messaging, { vapidKey, serviceWorkerRegistration: registration })
    console.log("6. Token:", token ? "OK" : "null")
    if (!token) return

    console.log("7. Envoi au serveur...")
    const response = await fetch("/device_tokens", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ token: token, platform: "web" })
    })
    console.log("8. Réponse:", response.status)
  } catch (e) {
    console.error("❌ Erreur FCM:", e)
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
