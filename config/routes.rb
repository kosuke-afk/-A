Rails.application.routes.draw do



  root 'static_pages#top'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection { 
      post :import 
      get :working_index
      get :basic_info
      post :basic_update
    }
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/over_time_approval'
      patch 'attendances/update_over_time_approval'
      get 'attendances/attendance_approval'
      patch 'attendances/update_attendance_approval'
      get 'attendances/attendance_log'
      get 'change_log'
      get 'months/one_month_approval'
      patch 'months/update_one_month_approval'
      
    end
    resources :attendances, only: :update do
      get 'over_time'
      patch 'update_over_time'
    end
    resources :months, only: :create 
  end
  
  resources :bases 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
