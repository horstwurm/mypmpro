Rails.application.routes.draw do

  resources :pplans
  resources :company_params
  resources :deputies
  
  #devise_for :users
  resources :charges
  resources :plannings
  resources :timetracks
  resources :qrcodes
  get 'rooms/show'

  resources :credentials
  root 'home#services'
  
  resources :webmasters

  get 'ticketuserview/index'
  get 'ticketuserview/index2'
  get 'users/ticketstatus'
  resources :tickets
  get 'statement/index'

  get 'showcal/index'
  get 'home/nutzung'
  get 'home/index'
  get 'home/index1'
  #get 'home/index1/:ticket_id', to: 'home#index1'
  get 'home/index2'
  get 'home/index6'
  get 'home/index7'
  get 'home/index8'
  get 'home/index9'
  get 'home/index10'
  get 'home/index11'
  get 'home/index12'
  get 'home/index13'
  get 'home/index14'
  get 'home/index15'
  get 'home/index16'
  get 'home/index17'
  get 'home/index18'
  get 'home/index20'
  get 'home/test'
  get 'home/import'
  get 'home/arduino'
  get 'home/dashboard'
  get 'home/dashboard2'
  get 'home/dashboard_project'
  get 'home/dashboard_data'
  get 'home/dashboard2_data'
  get 'home/dashboard_projectdata'
  get 'home/Umfragen_data'
  get 'home/readsensordata'
  get 'home/readLastValue'
  get 'home/writesensordata'
  get 'home/readusernotes'
  get 'home/writeusernotes'
  get 'home/readuser'
  get 'home/writeuserpos'
  get 'home/writeiot'
  get 'home/readiot'
  get 'home/alexa'
  get 'home/writeimage'
  get 'home/temptest'
  get 'home/switch'
  get 'home/readswitch'
  get 'home/migrate'
  get 'home/migrateDo'
  get 'home/services'
  get 'home/getProjects'
  get 'home/getProject'

  resources :searches
  resources :partner_links
  resources :mobjects
  resources :mdetails
  resources :mcategories
  resources :madvisors
  get 'listaccount/index'

  resources :emails
  get 'customer_advisor/index'

  get 'customer_advisor/index2'
  get 'appparams/updateuser'
  
  resources :companies
  resources :appparams
  resources :accounts

  root 'home#services'

  #devise_for :users, :controllers => {registrations: 'registrations'}
  #devise_for :users, :controllers => {registrations: 'registrations', passwords: 'passwords', confirmations: "confirmations"}
  devise_for :users, :controllers => {registrations: 'registrations', passwords: 'passwords'}
  
  resources :users
  resources :tests
  
  # mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
