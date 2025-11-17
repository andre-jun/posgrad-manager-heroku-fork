Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :students
  resources :reports
  resources :professors do
    member do
      get :student_info
    end
  end
  resources :administrators

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users
  resources :users_admin, controller: :users
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'student_home', to: 'students#home', as: 'student_home'
  get 'professor_home', to: 'professors#home', as: 'professor_home'
  get 'admin_home', to: 'administrators#home', as: 'adm_home'
  post :change_professor, to: 'students#change_professor'
  get 'export_pdf', to: 'administrators#export_pdf', as: 'export_pdf'
  get 'contact_info', to: 'users#contact_info', as: 'contact_info'
  get 'new_report_options', to: 'reports#new_report_options', as: 'new_report_options'
  post :copy_and_create, to: 'reports#copy_and_create', as: 'copy_and_create'
  get 'report_answers', to: 'reports#report_answers', as: 'report_answers'

  # tem que fazer o root directionar pra home certa dependendo do tipo de usuario
  authenticated :user do
    root to: 'pages#home', as: :authenticated_user_root
  end

  root 'pages#home'
  # Defines the root path route ("/")
  # root "posts#index"
end
