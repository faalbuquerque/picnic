Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :baskets, only: %i[index show create destroy]
      resources :foods, only: %i[index show create destroy]
    end
  end
end
