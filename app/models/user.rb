class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  AVATARS = %w[bear_avatar.jpg beaver_avatar.jpg cheetah_avatar.jpg giraffe_avatar.jpg
               hippopotamus_avatar.jpg parrot_avatar.jpg]
  validates :avatar, inclusion: { in: AVATARS }, allow_nil: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :lost_items
  has_many :found_items
  has_many :notifications, dependent: :destroy
  has_many :received_notes, class_name: "ThankYouNote", foreign_key: :recipient_id
  validates :first_name, presence: true
  validates :last_name, presence: true
end
