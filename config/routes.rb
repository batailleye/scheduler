Scheduler::Application.routes.draw do
  
  devise_for :users, :controllers => { :invitations => 'users/invitations' }
  
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match '' => 'home#index', :as => :login

  devise_scope :user do
    match 'admin/new_admin' => 'users/invitations#new', :as => 'new_admin'
    match 'admin/invite_admin' => 'users/invitations#create', :as => 'invite_admin'
  end
  
  scope '/admin/' do
    match 'upload' => 'admin#upload', :as => 'admin_upload'
    match 'calendar' => 'calendar#admin_index', :as => 'admin_calendar'
    match 'print' => 'calendar#admin_print', :as => 'admin_print'
    match 'rules' => 'admin#rules', :as => 'admin_rules'
    resources :nurse, :except => [:show], :as => 'nurse_manager' do
      collection do
        post 'upload'
        post 'finalize'
      end
    end
    resources :admins, :except => [:new, :create, :show], :controller => 'admin_manager'
    # if there become too many actions, we will instead use the following
    # match ':action' => 'admin#:action', :as => :admin
    resources :unit, :as => 'units'
  end
  
  scope 'nurse/:nurse_id/' do
    resources :calendar, :as => 'nurse_calendar' do
      collection do
        get 'print'
      end
    end
    match 'seniority' => 'nurse#seniority'
    resources :calendar, :as => 'nurse_calendar'
  end

   # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'home#index'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
