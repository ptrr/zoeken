Rails.application.routes.draw do
  root to: 'languages#index'
  resources :languages do 
    collection do
      get :search
    end
  end
end
