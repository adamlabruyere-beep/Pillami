class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create_commit :initialize_pillatheque
  after_create_commit :create_default_calendrier

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :prenom, presence: true
  validates :nom, presence: true

  has_one :pillatheque, dependent: :destroy
  has_one :calendrier


  has_many :reminders, dependent: :destroy

  def initialize_pillatheque
    Pillatheque.create(user: self)
  end

  def create_default_calendrier
    create_calendrier
  end
end
