Rails.application.routes.draw do
  resources :keys, only:[:show, :new]
  resources :messages, only:[:show, :encrypt, :decrypt]
  
  post '/rsas', to: 'keys#new'
  get '/rsas/:id', to: 'keys#show'
  post '/rsas/:id/encrypt_messages/', to: 'messages#encrypt'
  get '/rsas/:id/encrypt_messages/:messageid', to: 'messages#show'
  post '/rsas/:id/decrypt_messages/', to: 'messages#decrypt'

end
