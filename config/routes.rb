Rails.application.routes.draw do

  resource :users, only: %i[] do
    post '/sign_up', to: 'users#create'
    post '/sign_in', to: 'sessions#create'
    post '/sign_out', to: 'sessions#destroy'
  end

  scope '/profile' do
    get '/', to: 'user_profiles#my_profile'
    put '/', to: 'user_profiles#update'
  end

  resource :contacts, only: %i[] do
    get '/', to: 'contacts#index'
    get '/:contact_id/', to: 'contacts#show'
    put '/:contact_id/', to: 'contacts#update'
    delete '/:contact_id/', to: 'contacts#destroy'
    post '/', to: 'contacts#create'
  end

end
