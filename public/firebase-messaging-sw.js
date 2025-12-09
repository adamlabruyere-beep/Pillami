importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js")
importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js")

firebase.initializeApp({
  apiKey: "AIzaSyAwpB3lK5tNUgkqvnQWtOL91tP9IfRWDDE",
  authDomain: "pillami-e98ac.firebaseapp.com",
  projectId: "pillami-e98ac",
  messagingSenderId: "583918755836",
  appId: "1:583918755836:web:30cf6f69ebfe7f715b1c79"
})

const messaging = firebase.messaging()

messaging.onBackgroundMessage(function(payload) {
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
  })
})
