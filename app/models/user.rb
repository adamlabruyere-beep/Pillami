class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create_commit :initialize_pillatheque

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :prenom, presence: true
  validates :nom, presence: true

  has_one :pillatheque, dependent: :destroy
  has_one :calendrier



  def initialize_pillatheque
    Pillatheque.create(user: self)
  end
end
