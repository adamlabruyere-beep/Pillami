# Scheduler disabled - use Heroku Scheduler instead
# Run: rake reminder:run_notifications every hour
#
# To enable self-scheduling (for non-Heroku deployments):
# Set ENV["REMINDER_NOTIFICATIONS_SCHEDULER"] = "true"
#
# Rails.application.config.after_initialize do
#   if defined?(ReminderNotificationJob) && ReminderNotificationJob.scheduler_enabled?
#     ReminderNotificationJob.schedule_next_run
#   end
# end
