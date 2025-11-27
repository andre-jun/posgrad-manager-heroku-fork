Rails.application.routes.draw do
  # Depois a gente tem que reorganizar aqui tudo

  resource :complete_registration, only: %i[show update]

  namespace :admin do
    resources :students,       only: %i[new create edit update]
    resources :professors,     only: %i[new create edit update]
    resources :administrators, only: %i[new create edit update]
  end

  resources :students, only: %i[show edit update]
  resources :professors, only: %i[show edit update] do
    member do
      get :student_info
    end
  end

  resources :reports do
    collection do
      get :options
    end

    post :duplicate, on: :member
  end
  resources :report_infos, only: %i[show edit update]
  resources :publications

  devise_for :users, skip: [:registrations], controllers: {
    sessions: 'users/sessions'
  }

  get 'student_home',   to: 'students#home',      as: 'student_home'
  get 'professor_home', to: 'professors#home',    as: 'professor_home'
  get 'admin_home',     to: 'administrators#home', as: 'adm_home'

  get 'up' => 'rails/health#show', as: :rails_health_check

  post :change_professor, to: 'students#change_professor'
  get 'export_pdf', to: 'administrators#export_pdf', as: 'export_pdf'
  get 'contact_info', to: 'users#contact_info', as: 'contact_info'
  get 'new_report_options', to: 'reports#new_report_options', as: 'new_report_options'
  post :copy_and_create, to: 'reports#copy_and_create', as: 'copy_and_create'
  get 'report_answers', to: 'reports#report_answers', as: 'report_answers'
  get 'student_send_report', to: 'students#send_report', as: 'student_send_report'
  get 'professor_send_report', to: 'professors#send_report', as: 'professor_send_report'
  get 'administrator_send_report', to: 'administrators#send_report', as: 'administrator_send_report'
  # get 'administrator_send_report', to: 'reports#send_report', as: 'administrator_send_report'

  # esse aqui é só pra simular uma aba, dps vai virar só um parcial eu acho
  get 'professor_report_temp', to: 'professors#temp_report', as: 'prof_temp'

  # tem que fazer o root directionar pra home certa dependendo do tipo de usuario
  root to: 'application#root_redirect'
end
