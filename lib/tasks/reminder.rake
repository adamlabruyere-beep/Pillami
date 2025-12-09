namespace :reminder do
  desc "Send pending reminder notifications"
  task run_notifications: :environment do
    puts "[#{Time.current}] Running ReminderNotificationJob..."
    ReminderNotificationJob.perform_now
    puts "[#{Time.current}] Done."
  end
end
