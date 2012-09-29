DominionCardsApp::Application.routes.draw do
  resources :cards, only: [:show, :index, :create]
  root to: 'home#index'
end
