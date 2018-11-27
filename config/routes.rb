Rails.application.routes.draw do

  devise_for :admins
  namespace :admin do
    get 'dashboard/overview'
  end
  if Rails.env.development? or Rails.env.staging?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  match '/mailchimp_callback', to: 'application#mailchimp_callback', as: :mailchimp_callback, via: [:get, :post]
  match '/unsubscribe', to: 'application#mailchimp_unsubscribe', as: :mailchimp_unsubscribe, via: %i[get post]
  match '/thank_you', to: 'application#thank_you', as: :thank_you, via: :get


  match '/enable_admin_mailer', to: 'application#enable_admin_mailer', as: :enable_admin_mailer, via: :get
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  devise_scope :admin do
    root to: "devise/sessions#new"
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
