DominionCardsApp::Application.routes.draw do
  resources :picks, only: [:show, :index, :create]
  resources :cards, only: [:show, :index]
  root to: 'home#index'
end
