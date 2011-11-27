Yaif::Application.routes.draw do
  resources :users, :only => [:new, :create, :edit, :update]
  resources :sessions, :only => [:new, :create, :destroy]

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  root :to => 'sessions#root'
end
