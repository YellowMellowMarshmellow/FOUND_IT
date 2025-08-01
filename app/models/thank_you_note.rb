class ThankYouNote < ApplicationRecord

  belongs_to :recipient, class_name: "User"

end
