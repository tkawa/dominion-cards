DominionCardsApp::Application.routes.draw do
  resources :cards, only: [:show, :index, :create] do
    get ':ids', to: 'cards#pick', on: :collection, constraints: {ids: /\w+\,\w/}
  end
  root to: 'home#index'
end
