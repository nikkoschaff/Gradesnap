Gradesnap::Application.routes.draw do
  resources :scansheets 
  resources :assignments do
    collection do
      post 'select_course'
      post 'select_assignment'
      get 'select_course'
      get 'select_assignment'
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

  #prelogin page
  root :to => 'prelogins#index'

 

  match '/home' => 'prelogins#index'
  match '/features' => 'prelogins#features'
  match '/about' => 'prelogins#about'
  match '/contact' => 'prelogins#contact'
  match '/sign' => 'prelogins#sign'
  match '/forgot_password' => 'prelogins#forgot_password'
  match '/legal' => 'prelogins#legal'  

  #session pages
  match '/dashboard' => 'sessions#dashboard'
  match '/logout' => 'sessions#logout'
  match '/change_password' => 'sessions#change_password'
  match '/my_account' => 'sessions#myaccount'
  match '/payment' => 'sessions#payment'

  #stats pages
  match '/stats' => 'stats#index'

  #assignments pages
  match '/assignments/key', to: 'assignments#key'
  match '/assignments/stats_m', to: 'stats#stats_main', :as => 'statsmain'

  #scan pages
  match '/scansheets' => 'stats#stats_main'

  #spreadsheet pages
  match '/spreadsheets' => 'stats#stats_main'

  # This is a legacy line that should never be used or it de-RESTs the app
  # match ':controller(/:action(/:id))(.:format)'
end
