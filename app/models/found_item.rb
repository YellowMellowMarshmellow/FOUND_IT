class FoundItem < ApplicationRecord
  belongs_to :user
  has_many :matches
  has_many :lost_items, through: :matches
  has_many :claims, through: :matches
  has_many_attached :images

  include ItemCategories

  validates :category, presence: true, inclusion: { in: ItemCategories::CATEGORIES }
  validates :title, :location, :date_reported, :category, presence: true
  validates :description, presence: true, length: { minimum: 30, message: "must be at least 30 characters long" }
  validates :images, presence: true
  validate :images_count_within_limit

  before_save :normalize_fields

  private

  def normalize_fields
    self.location = location.strip.split.map(&:capitalize).join(' ')
    matched_category = ItemCategories::CATEGORIES.find { |c| c.casecmp?(category.strip) }
    self.category = matched_category || category.strip
  end

  def images_count_within_limit
    return unless images.attached?

    errors.add(:images, "You can upload up to 3 images.") if images.count > 3
  end
end
