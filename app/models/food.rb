class Food < ApplicationRecord
  belongs_to :basket

  validates :name, presence: true
end
