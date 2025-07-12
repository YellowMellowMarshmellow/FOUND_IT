class FoundItem < ApplicationRecord
  belongs_to :user
  has_many :matches, foreign_key: :item_id
  has_many :claims, through: :matches
end
