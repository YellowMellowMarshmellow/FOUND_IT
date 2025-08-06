class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lost_items
  has_many :found_items
  has_many :notifications, dependent: :destroy
  has_many :received_notes, class_name: "ThankYouNote", foreign_key: :recipient_id

  # Active Storage for avatar (will use Cloudinary as storage backend)
  has_one_attached :avatar
  # devise can do all this you dont need it
  # validates :avatar, inclusion: { in: AVATARS }, allow_blank: true
  # validates :password, presence: true, confirmation: true, length: { minimum: 6 }, if: :password_required?

  # def password_required?
  #   !password.blank? || !password_confirmation.blank?
  # end
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Helper methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def display_avatar
    if avatar.attached?
      avatar
    else
      # Default avatar from Cloudinary
      "https://res.cloudinary.com/yellowmellowmarshmellow/image/upload/v1754386878/bear_avatar_qzuzxr.png"
    end
  end

  # Class method to get available avatar options
  def self.avatar_options
    AVATAR_OPTIONS
  end
end
