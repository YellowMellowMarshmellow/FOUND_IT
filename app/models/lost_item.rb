class LostItem < ApplicationRecord
  belongs_to :user
  has_many :matches, foreign_key: :lost_item_id, dependent: :destroy
  has_many :found_items, through: matches


  has_many_attached :images

  include ItemCategories

  validates :category, presence: true, inclusion: { in: ItemCategories::CATEGORIES }

  validates :title, :description, :location, :date_lost, :category, presence: true
  validates :images, presence: true

  validates :title, :location, :date_lost, :category, presence: true
  validates :description, presence: true, length: { minimum: 30, message: "must be at least 30 characters long" }
  #validates :images, presence: true

  validate :images_count_within_limit

  private

  def images_count_within_limit
    return unless images.attached?
    errors.add(:images, "You can upload up to 3 images.") if images.count > 3
  end
end
