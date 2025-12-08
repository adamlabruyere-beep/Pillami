class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create_commit :initialize_pillatheque
  after_create_commit :create_default_calendrier
  after_create_commit :initialize_profile_photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :prenom, presence: true
  validates :nom, presence: true

  has_one :pillatheque, dependent: :destroy
  has_one :calendrier

  has_many :reminders, dependent: :destroy
  has_many :sensations, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :device_tokens, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :photo

  def initialize_pillatheque
    Pillatheque.create(user: self)
  end

  def create_default_calendrier
    create_calendrier
  end

  def initialize_profile_photo
    require "open-uri"

    self.photo.attach(
    io: URI.open("https://res.cloudinary.com/dpyoe1s3a/image/upload/v1764942362/BlankAvatar_zbx9p6.png"),
    filename: "basic_profile.jpg"
    )
  end
end
