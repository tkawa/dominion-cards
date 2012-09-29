DominionCardsApp::Application.routes.draw do
  resources :cards, only: [:show, :index, :create] do
    get ':ids', to: 'cards#pick', on: :collection, constraint: {ids: /^\w+,\w/}
  end
end
