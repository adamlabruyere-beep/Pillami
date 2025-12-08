class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :reminder

  scope :pending,  -> { where(status: false).where("scheduled_for <= ?", Time.current) }
  scope :unread,  -> { where(status: false) }
  scope :due,     -> { where("scheduled_for <= ?", Time.current) }
end
