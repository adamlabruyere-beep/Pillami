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
  console.log("🔔 registerPushToken() appelé")

  try {
    // 1. Vérifier le support
    if (!("serviceWorker" in navigator) || !("PushManager" in window)) {
      console.log("❌ Push non supporté par ce navigateur")
      return
    }

    // 2. Demander la permission d'abord
    console.log("1. Demande de permission...")
    const permission = await Notification.requestPermission()
    console.log("2. Permission:", permission)
    if (permission !== "granted") {
      console.log("❌ Permission refusée")
      return
    }

    // 3. Attendre que le SW soit prêt
    console.log("3. Attente du Service Worker...")
    const registration = await navigator.serviceWorker.ready
    console.log("4. SW prêt:", registration.active?.state)

    // 4. Initialiser Firebase
    console.log("5. Init Firebase...")
    const app = initializeApp(firebaseConfig)
    const messaging = getMessaging(app)

    // 5. Obtenir le token
    console.log("6. Demande du token FCM...")
    const token = await getToken(messaging, {
      vapidKey,
      serviceWorkerRegistration: registration
    })

    if (!token) {
      console.log("❌ Pas de token reçu")
      return
    }
    console.log("7. Token reçu:", token.substring(0, 30) + "...")

    // 6. Envoyer au serveur
    console.log("8. Envoi au serveur...")
    const response = await fetch("/device_tokens", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ token, platform: "web" })
    })
    console.log("9. Réponse:", response.status, response.ok ? "✅" : "❌")

  } catch (e) {
    console.error("❌ Erreur FCM:", e)
  }
}

// Enregistrer le SW une seule fois au chargement
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/firebase-messaging-sw.js")
    .then(reg => console.log("✅ SW enregistré:", reg.scope))
    .catch(err => console.error("❌ SW erreur:", err))
}
