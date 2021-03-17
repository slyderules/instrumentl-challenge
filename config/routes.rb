Rails.application.routes.draw do
  resources :awards
  resources :receivers
  resources :filers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

   get   '/parse_awards',    to: 'awards#parse_awards' 
   get   '/parse_filers',    to: 'filers#parse_filers' 
   get   '/parse_receivers',    to: 'receivers#parse_receivers' 

end
