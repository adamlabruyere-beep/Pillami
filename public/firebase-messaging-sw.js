self.addEventListener("push", function(event) {
  console.log("📩 Push reçu:", event)

  let data = {}
  try {
    data = event.data?.json() || {}
  } catch (e) {
    console.error("Erreur parsing push data:", e)
  }

  const title = data.data?.title || "Pillami"
  const body = data.data?.body || ""

  event.waitUntil(
    self.registration.showNotification(title, {
      body: body,
      icon: "/favicon-32x32.png"
    })
  )
})
