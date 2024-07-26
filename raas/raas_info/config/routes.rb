Rails.application.routes.draw do
  get 'update/run'

  resources :shards
  resources :endpoints
  resources :dbs
  resources :nodes
  resources :clusters
  root 'dbs#index'
  # legacy paths in http://raas-info we shared in wiki/confluence
  get "/dbs1.html" => redirect("/")
  get "/dbs2.html" => redirect("/")
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
