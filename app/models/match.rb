class Match < ApplicationRecord
  belongs_to :claim
  belongs_to :found_item
end
