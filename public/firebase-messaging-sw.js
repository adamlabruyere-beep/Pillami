self.addEventListener("push", function(event) {
  console.log("📩 Push reçu:", event.data?.text())

  let title = "Pillami"
  let body = ""

  try {
    const payload = event.data?.json()
    // FCM envoie les data dans payload.data directement
    title = payload?.data?.title || payload?.notification?.title || "Pillami"
    body = payload?.data?.body || payload?.notification?.body || ""
  } catch (e) {
    console.error("Erreur parsing push data:", e)
  }

  event.waitUntil(
    self.registration.showNotification(title, {
      body: body,
      icon: "/favicon-32x32.png"
    })
  )
})
