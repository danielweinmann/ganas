Rails.application.routes.draw do

  root "classes#index"

  resources :classes, only: [] do
    collection do
      get :meme
    end
  end

end
