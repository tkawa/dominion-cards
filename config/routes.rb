DominionCardsApp::Application.routes.draw do
  resources :cards, only: [:show, :index]
end
