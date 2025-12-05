class SendReminderJob < ApplicationJob
  queue_as :default

  def perform(reminder_id)
    reminder = Reminder.find(reminder_id)
    return unless reminder.active?

    # HTML de l'alerte cliquable
    alert_html = %(
      <div class="reminder-alert" style="padding: 10px; background: #ffd700; border-radius: 5px; margin: 5px; cursor: pointer;"
           onclick="window.location.href='/reminders';">
          #{reminder.medicament.nom} - #{reminder.message}
      </div>
    )

    SolidCable.broadcast_to(
      "reminders_#{reminder.user.id}",
      alert: alert_html
    )
  end
end
