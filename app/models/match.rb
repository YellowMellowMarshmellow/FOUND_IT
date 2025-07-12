class Match < ApplicationRecord
  belongs_to :claim
  belongs to :found_item
end
