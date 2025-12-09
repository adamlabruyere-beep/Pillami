importScripts("https://www.gstatic.com/firebasejs/10.13.0/firebase-app-compat.js")
importScripts("https://www.gstatic.com/firebasejs/10.13.0/firebase-messaging-compat.js")

firebase.initializeApp({
  apiKey: "AIzaSyAwpB3lK5tNUgkqvnQWtOL91tP9IfRWDDE",
  authDomain: "pillami-e98ac.firebaseapp.com",
  projectId: "pillami-e98ac",
  storageBucket: "pillami-e98ac.firebasestorage.app",
  messagingSenderId: "583918755836",
  appId: "1:583918755836:web:30cf6f69ebfe7f715b1c79",
  measurementId: "G-6FKSN2SZ8F"
})

const messaging = firebase.messaging()

messaging.onBackgroundMessage(function(payload) {
  console.log("📩 Message reçu en background:", payload)
  // FCM affiche automatiquement la notification quand le champ 'notification' est présent
  // Pas besoin d'appeler showNotification manuellement
})
