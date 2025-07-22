class Match < ApplicationRecord
  belongs_to :lost_item
  belongs_to :found_item
end
