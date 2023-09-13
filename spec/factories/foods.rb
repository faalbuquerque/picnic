FactoryBot.define do
  factory(:food) do
    name { Faker::Food.fruits }

    association :basket, factory: :basket
  end
end