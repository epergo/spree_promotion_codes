Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :promotions do
      resources :promotion_codes
    end
  end
end
