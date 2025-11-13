class Category < ApplicationRecord

  has_many :tweets
  validates :name, uniqueness: true
  
end
