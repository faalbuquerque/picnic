FactoryBot.define do
  factory(:basket) do
    name { "Basket of #{Faker::Emotion.noun}" }
  end
end