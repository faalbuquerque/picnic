class Basket < ApplicationRecord
  has_many :foods, dependent: :destroy
end
