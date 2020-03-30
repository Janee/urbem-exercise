Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  constraints format: :json do
    post '/urbem' => 'webhooks#receive', as: :receive_webhooks
  end

end
