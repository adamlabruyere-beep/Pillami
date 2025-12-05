class Entourage < ApplicationRecord
  belongs_to :user

  has_many :entourage_members, dependent: :destroy
  has_many :members, through: :entourage_members, source: :user

  validates :name, presence: true

  def add_member(user, role: "membre")
    entourage_members.create(user: user, role: role)
  end

  def remove_member(user)
    entourage_members.find_by(user: user)&.destroy
  end

  def member?(user)
    members.include?(user)
  end
end
