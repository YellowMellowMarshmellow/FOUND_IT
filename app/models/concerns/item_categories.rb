module ItemCategories
  extend ActiveSupport::Concern

  CATEGORIES = [
    'Clothing',
    'Shoes',
    'Accessories',
    'Electronics',
    'Documents',
    'Toys',
    'Keys',
    'Wallets',
    'Others'
  ].freeze
end
