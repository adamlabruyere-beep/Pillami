if ReminderNotificationJob.scheduler_enabled?
  Rails.application.config.after_initialize do
    ReminderNotificationJob.schedule_next_run
  end
end
