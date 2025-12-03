console.log('aaa');

function initCalendarInteractions() {
  const days = document.querySelectorAll(".calendar-day");
  const panel = document.getElementById("calendar-panel");

  if (!days.length || !panel) return;

  days.forEach((day) => {
    day.addEventListener("click", () => {
      // 1. Visuel : marquer le jour sélectionné
      days.forEach(d => d.classList.remove("selected-day"));
      day.classList.add("selected-day");

      // 2. Récupérer les infos de la date
      const rawDate   = day.dataset.date;     // "2025-12-01"
      const weekday   = day.dataset.weekday;  // "lundi"
      const monthName = day.dataset.month;    // "décembre"
      const dayNumber = day.querySelector("p:nth-child(2)")?.textContent;

      // 3. Mettre à jour le panneau
      panel.innerHTML = `
        <div class="border rounded-2xl shadow p-4 bg-white">
          <h2 style="font-weight:600; margin-bottom:0.5rem; text-align:center;">
            ${weekday} ${dayNumber} ${monthName}
          </h2>
          <p style="font-size:0.9rem; color:#4b5563;">
            Ici tu pourras afficher les éléments de cette journée
            (médicaments, notes, formulaires, etc.).
          </p>
          <p style="font-size:0.75rem; color:#9ca3af; margin-top:0.5rem;">
            Date brute : ${rawDate}
          </p>
        </div>
      `;
    });
  });
}

// Avec Turbo (Rails 7)
document.addEventListener("turbo:load", initCalendarInteractions);
// Si tu n'utilises pas Turbo, tu peux aussi faire :
// document.addEventListener("DOMContentLoaded", initCalendarInteractions);
