Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "pages#home"

  resources :pages, only: [:new, :create]

  get "/:slug",
    to: "pages#show",
    as: :page,
    constraints: { slug: /[^\/]+/ } # allow dots in slugs
end
