class Claim < ApplicationRecord
  belongs_to :user
  has_many :matches
  has_many :found_items, through: :matches
end
