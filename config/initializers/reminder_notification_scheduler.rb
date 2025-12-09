Rails.application.config.after_initialize do
  if defined?(ReminderNotificationJob) && ReminderNotificationJob.scheduler_enabled?
    ReminderNotificationJob.schedule_next_run
  end
end
