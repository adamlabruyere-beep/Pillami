class ReminderNotificationJob < ApplicationJob
  queue_as :default
  after_perform :schedule_next_run_if_enabled

  def perform
    now          = Time.current
    today        = now.to_date
    weekday_name = Date::DAYNAMES[today.wday]

    current_minutes = now.hour * 60 + now.min

    Reminder.includes(:user, :medicament).find_each do |reminder|
      # 1. doit être actif
      next unless reminder.active?

      # 2. Bon jour de la semaine
      days = reminder.days_of_week || []
      next unless days.include?(weekday_name)

      # 3. Gestion de repeat_for_weeks
      created   = reminder.created_at.to_date
      days_diff = (today - created).to_i
      next if days_diff < 0 # pas de rappel avant la création

      weeks = (reminder.repeat_for_weeks || 1).to_i
      weeks = 1 if weeks <= 0

      weeks_diff = days_diff / 7
      next if weeks_diff >= weeks # on a dépassé la durée

      # 4. Heure du rappel ≈ heure actuelle
      next unless reminder.time

      reminder_minutes = reminder.time.hour * 60 + reminder.time.min
      # job toutes les 10 min → fenêtre de 10 minutes
      next unless (current_minutes - reminder_minutes).between?(0, 9)

      # 5. éviter plusieurs notifs pour le même rappel aujourd'hui
      already_sent = Notification.exists?(
        user:     reminder.user,
        reminder: reminder,
        created_at: now.beginning_of_day..now.end_of_day
      )
      next if already_sent

      # 6. créer la notification + push
      notification = Notification.create!(
        user:     reminder.user,
        reminder: reminder,
        time:     now,
        status:   false,
        message:  build_message(reminder, now),
        scheduled_for: scheduled_time_for(reminder, now)
      )

      send_push_for(notification)
    end
  end

  private

  def build_message(reminder, now)
    time_str = reminder.time&.strftime("%H:%M") || now.strftime("%H:%M")
    med_name = reminder.medicament&.nom || "Votre médicament"
    "#{med_name} — c'est l'heure de le prendre (#{time_str})"
  end

  def send_push_for(notification)
    user     = notification.user
    reminder = notification.reminder

    title    = "💊 Pillami"
    time_str = reminder.time&.strftime("%H:%M") || Time.current.strftime("%H:%M")
    body     = "#{reminder.medicament&.nom || 'Votre médicament'} — c'est l'heure (#{time_str})"

    sender = Firebase::PushSender.new

    user.device_tokens.find_each do |device|
      result = sender.send_to_token(
        token: device.token,
        title: title,
        body:  body
      )

      # Supprimer les tokens invalides
      if result == :unregistered
        Rails.logger.info("Deleting unregistered token #{device.id}")
        device.destroy
      end
    end
  end

  def self.schedule_next_run
    next_run = Time.current.beginning_of_hour + 1.hour
    set(wait_until: next_run).perform_later
  end

  def self.scheduler_enabled?
    ActiveModel::Type::Boolean.new.cast(
      ENV.fetch("REMINDER_NOTIFICATIONS_SCHEDULER", "true")
    )
  end

  private

  def scheduled_time_for(reminder, now)
    return now unless reminder.time

    now.change(hour: reminder.time.hour, min: reminder.time.min, sec: 0)
  end

  def schedule_next_run_if_enabled
    self.class.schedule_next_run if self.class.scheduler_enabled?
  end
end
