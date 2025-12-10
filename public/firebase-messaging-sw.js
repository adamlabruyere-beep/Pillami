const CACHE_NAME = "pillami-v1"
const STATIC_ASSETS = [
  "/",
  "/favicon.ico",
  "/favicon-32x32.png",
  "/favicon-16x16.png",
  "/apple-touch-icon.png",
  "/android-chrome-192x192.png",
  "/android-chrome-512x512.png"
]

// Installation : mise en cache des assets statiques
self.addEventListener("install", function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll(STATIC_ASSETS)
    })
  )
  self.skipWaiting()
})

// Activation : nettoyage des anciens caches
self.addEventListener("activate", function(event) {
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.filter(function(cacheName) {
          return cacheName !== CACHE_NAME
        }).map(function(cacheName) {
          return caches.delete(cacheName)
        })
      )
    })
  )
  self.clients.claim()
})

// Fetch : stratégie network-first avec fallback cache
self.addEventListener("fetch", function(event) {
  // Ignorer les requêtes non-GET
  if (event.request.method !== "GET") return

  event.respondWith(
    fetch(event.request)
      .then(function(response) {
        // Mettre en cache la réponse
        if (response.status === 200) {
          const responseClone = response.clone()
          caches.open(CACHE_NAME).then(function(cache) {
            cache.put(event.request, responseClone)
          })
        }
        return response
      })
      .catch(function() {
        // Fallback sur le cache si offline
        return caches.match(event.request)
      })
  )
})

// Push notifications
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
      icon: "/android-chrome-192x192.png",
      badge: "/favicon-32x32.png",
      vibrate: [200, 100, 200],
      tag: "pillami-notification"
    })
  )
})

// Clic sur notification
self.addEventListener("notificationclick", function(event) {
  event.notification.close()
  event.waitUntil(
    clients.openWindow("/")
  )
})
