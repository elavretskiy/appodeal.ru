Rails.application.routes.draw do
  root 'main#index'
  get 'load_data', to: 'main#load_data'
  get 'create_pad', to: 'main#create_pad'
  get 'load_pads', to: 'main#load_pads'
end
