Gradesnap::Application.routes.draw do
  root :to => 'application#find_root_url'

  resources :contacts
 
  resources :exportsheets

  resources :users
  resources :scansheets 
  resources :assignments do
    collection do
      get 'mod'
      post 'post_mod'
      get 'make'
      post 'post_make'
    end
  end
  resources :importsheets do
    collection do 
      post 'import'
      get 'import'
    end
  end
  resources :prelogins do
    collection do
      get 'login'
      post 'login'
      get 'forgot_password'
      post 'forgot_password'
      get 'legal'
    end
  end
  resources :assignments
  resources :notifications
  resources :assignments_students do
    collection do
      get 'mod'
      post 'mod'
    end
  end
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

  match "/prelogins/:id/code" => "prelogins#confirmation_code"



  #session pages
  match '/dashboard' => 'sessions#dashboard'
  match '/logout' => 'sessions#logout'
  match '/change_password' => 'sessions#change_password'
  match '/change_email' => 'sessions#change_email'
  match '/my_account' => 'sessions#myaccount'
  match '/payment' => 'sessions#payment'

  #assignments pages
  match '/assignments/key' => 'assignments#key'

  #Issue pages
  match '/issues/resolveAnswerverify' => 'issues#resolveAnswerverify'
  match '/issues/resolveNameverify' => 'issues#resolveNameverify'
end
