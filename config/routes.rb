Gradesnap::Application.routes.draw do
  resources :contacts do
    collection do
      get 'login'
      post 'new'
      get 'new'
      get 'post_contact'
      post 'post_contact'
    end
  end

  resources :exportsheets

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
      get 'thanks'
      post 'confirm_eula'
      get 'eula'
      get 'signup'
      post 'signup'
      get 'login'
      post 'login'
      get 'forgot_password'
      get 'features'
      get 'about'
      get 'registration'
      get 'legal'
      get 'confirm_it'
      get 'confirmed_it'
      post 'confirmed_it'
    end
  end
  resources :assignments
  resources :notifications
  resources :assignment_students do
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

  #prelogin page
  root :to => 'prelogins#index'

  match '/pricing' => 'prelogins#pricing'
  #session pages
  match '/dashboard' => 'sessions#dashboard'
  match '/logout' => 'sessions#logout'
  match '/change_password' => 'sessions#change_password'
  match '/my_account' => 'sessions#myaccount'
  match '/payment' => 'sessions#payment'

  #assignments pages
  match '/assignments/key' => 'assignments#key'

  #Issue pages
  match '/issues/resolveAnswerverify' => 'issues#resolveAnswerverify'
  match '/issues/resolveNameverify' => 'issues#resolveNameverify'


  # This is a legacy line that should never be used or it de-RESTs the app
  # match ':controller(/:action(/:id))(.:format)'
end
