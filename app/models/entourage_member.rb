class EntourageMember < ApplicationRecord
  belongs_to :entourage
  belongs_to :user

  validates :user_id, uniqueness: { scope: :entourage_id, message: "est déjà membre de cet entourage" }
end
