Gradesnap::Application.routes.draw do
  resources :scansheets 
  resources :assignments do
    collection do
      get 'mod'
      post 'post_mod'
      get 'make'
      post 'post_make'
    end
  end
  resources :excelsheets do
    collection do 
      post 'import'
      get 'import'
    end
  end
  resources :prelogins
  resources :assignments
  resources :notifications
  resources :assignment_students
  resources :sessions
  resources :shared
  resources :stats
  resources :students
  resources :courses
  resources :issues 
  resources :stats do
	collection do 
		get 'courses'
		get 'assignments'
		get 'students'
  	end
  end
  resources :issues do 
    collection do 
      get 'resolve'
      post 'resolve'
    end
  end


  #prelogin page
  root :to => 'prelogins#index'

  match '/home' => 'prelogins#index'
  match '/features' => 'prelogins#features'
  match '/about' => 'prelogins#about'
  match '/contact' => 'prelogins#contact'
  match '/registration' => 'prelogins#registration'
  match '/forgot_password' => 'prelogins#forgot_password'
  match '/legal' => 'prelogins#legal'  
  match '/signup' => 'prelogins#signup'
  match '/login' => 'prelogins#login'

  #session pages
  match '/dashboard' => 'sessions#dashboard'
  match '/logout' => 'sessions#logout'
  match '/change_password' => 'sessions#change_password'
  match '/my_account' => 'sessions#myaccount'
  match '/payment' => 'sessions#payment'

  #stats pages
  match '/stats' => 'stats#index'

  #assignments pages
  match '/assignments/key' => 'assignments#key'

  # This is a legacy line that should never be used or it de-RESTs the app
  # match ':controller(/:action(/:id))(.:format)'
end
