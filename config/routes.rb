Rails.application.routes.draw do
  use_doorkeeper
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  namespace :admin do
    resources :mentors
    resources :words
    resources :stories, only: [:index, :new, :create, :edit, :update]
    resources :home, only: [:index], path: 'dashboard'
    resources :reports, only: [:index, :show] do
      post :process_report, on: :member
      post :reviewed, on: :member
    end
    resources :users, only: [:index] do
      collection do
        get :inactive
        get :banned
      end
      post :unban, on: :member
      post :create_mentor, on: :member
    end
    resources :feedbacks, only: [:index, :show]
  end

  resources :hash_tags, format: :json
  resources :reports
  # get '/invites/:provider/contact_callback' => "invites#contacts_callback"

  # get "/contacts/failure" => "invites#failure"
  # root :to => "invites#index"
  resources :friends, only: [:index] do
    post 'fb_friends', on: :collection
  end

  resources :feedbacks, only: [:create]

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'home#index'
  get 'home/login', to: 'home#login', as: 'login'
  get 'home/about_us', to: 'home#about_us', as: 'about_us'
  get 'home/about_jesus', to: 'home#about_jesus', as: 'about_jesus'
  get 'home/careers', to: 'home#careers', as: 'careers'
  get 'home/privacy_policy', to: 'home#privacy_policy', as: 'privacy_policy'
  get 'home/terms', to: 'home#terms', as: 'terms'
  get 'home/help', to: 'home#help', as: 'help_new'
  get 'home/press', to: 'home#press', as: 'press_new'
  get 'home/feedback', to: 'home#feedback', as: 'feedback'
  get 'home/beta_notification', to: 'home#beta_notification', as: 'beta_notification', path: '/notification'
  get 'promo/mobile_app', to: 'home#mobile_app'
  get 'dl', to: 'home#dl'

  namespace :dashboard do
    get '/search', to: 'search#index'
    get '/search/get_autocomplete_data', to: 'search#get_autocomplete_data'
    get '/welcome_1', to: 'welcome#hash_tags', as: 'welcome_first'
    post '/welcome_1/hash_tags', to: 'welcome#submit_hash_tags', as: 'welcome_hash_tags'
    get '/welcome_2', to: 'welcome#user_info', as: 'welcome_second'
    get '/welcome_3', to: 'welcome#invite_people', as: 'welcome_third'
    post '/welcome_3/send_invitations', to: 'welcome#send_invitations', as: 'welcome_send_invitations'
    put '/update_user_info', to: 'welcome#update_user_info', as: 'update_user_info'
    get '/finish_registration', to: 'welcome#finish_registration', as: 'finish_registration'
    # get 'users/:id/notifications', to: "users#notifications", as: 'notifications'y
    get '/users/unsubscribe/:signature', to: 'users#unsubscribe', as: :unsubscribe

    post 'contents/:content_id/comments', to: 'comments#create', as: 'comments'
    put 'comments/:comment_id', to: 'comments#update', as: 'comment'

    get 'contents/stories', to: 'contents#stories'
    resources :invites, only: [:index, :create]
    resources :contents do
      member do
        put 'like'
        put 'dislike'
        put 'update_picture'
        get 'comments', to: 'comments#index'
      end
    end

    get 'users/:id/inbox', to: 'users#inbox', as: 'inbox'
    get 'users/:id/preferences', to: 'users#preferences', as: 'preferences'
    get 'users/:id/profile', to: 'users#profile', as: 'profile'
    # get 'users/:id/followers', to: "users#followers", as: 'followers'
    # get 'users/:id/following', to: "users#following", as: 'following'

    resources :users, only: [:show, :update] do
      put :profile_avatar, on: :member
      put :profile_cover, on: :member

      resources :conversations, only: [:index]
      resources :notifications, only: [:index]
      member do
        get :news_feed
        get :following, action: :relationship, method: :following
        get :followers, action: :relationship, method: :followers
      end

      collection do
        put :update_password
        get :suggested
      end
    end

    resources :conversations do
      member do
        get :read_messages
      end

      collection do
        get :chat_list
      end

      resources :messages
    end
    resources :messages do
      collection do
        get :trashed
        get :search_receiver
      end
      member do
        post :retrieve_message
      end
    end

    resources :shares, only: :create do
      delete '/remove', to: 'shares#destroy_by_content_id', on: :collection
    end
  end
  resources :users do
    collection do
      get 'get_users', to: 'users#get_users'
    end
    resources :appointments, only: [:create]
  end
  resources :relationships, only: [:create, :destroy]
  namespace :api, defaults: { format: 'json' } do
    get 'documentation' => redirect('/swagger/dist/index.html?url=/api/v1/documentations#/default')

    namespace :v1 do
      resources :documentations, only: :index

      namespace :mobile do
        get :dashboard, to: 'dashboard#show'
        get :mentor, to: 'mentor#show'
        get :search, to: 'search#index'
        get '/search/:type', to: 'search#by_type'
        resources :comments, only: [:create, :update]
        resources :hash_tags, only: :index do
          get :autocomplete_hash_tags, on: :collection
        end
        resources :relationships, only: :create do
          post :follow, on: :collection
          post :unfollow, on: :collection
        end
        resources :statuses, only: [:create, :show, :update]
        resources :pictures, only: [:create, :show, :update]
        resources :stories, only: [:create, :show, :update]

        resources :users, only: [:create, :update] do
          get :me, on: :collection
          get :profile, on: :member
          post :update_fcm_token, on: :member
          post :remove_fcm_token, on: :member
          put :cover, on: :member
          get :unread_message_count, on: :member
          get :following, on: :collection
          get :followers, on: :collection
          get :search_following, on: :collection
          resources :appointments, only: [:create]
          resources :hash_tags, controller: 'user_hash_tags', only: [:index, :create]
          post :password, to: 'passwords#create', on: :collection
          put :password, to: 'passwords#update', on: :collection
        end
        resources :suggested_users, only: :index
        resources :reports, only: :create
        resources :conversations, only: [:show, :index] do
          get :unread_message_count, on: :member
          get :read_messages, on: :member
        end
        resources :notifications, only: :index
        resources :messages, only: [:create, :destroy] do
          get :deleted, on: :collection
        end
        resources :contents, only: [:index, :destroy] do
          member do
            post :like
            post :dislike
          end
        end
        resources :invitations, only: :create
        resources :shares, only: :create do
          delete '/', to: 'shares#destroy', on: :collection
        end
      end

      namespace :pub do
        get :dashboard, to: 'dashboard#show'
        get :mentor, to: 'mentor#show'
        get :search, to: 'search#index'
        get '/search/:type', to: 'search#by_type'
        resources :comments, only: [:create, :update]
        resources :hash_tags, only: :index do
          get :autocomplete_hash_tags, on: :collection
        end
        resources :relationships, only: :create do
          post :follow, on: :collection
          post :unfollow, on: :collection
        end
        resources :statuses, only: [:create, :show, :update]
        resources :stories, only: [:create, :show, :update]
        resources :pictures, only: [:create, :show, :update]

        resources :users, only: [:create, :update] do
          get :me, on: :collection
          get :profile, on: :member
          post :update_fcm_token, on: :member
          post :remove_fcm_token, on: :member
          put :cover, on: :member
          get :unread_message_count, on: :member
          get :following, on: :collection
          get :followers, on: :collection
          get :search_following, on: :collection
          resources :appointments, only: [:create]
          resources :hash_tags, controller: 'user_hash_tags', only: [:index, :create]
          post :password, to: 'passwords#create', on: :collection
          put :password, to: 'passwords#update', on: :collection
        end
        resources :suggested_users, only: :index
        resources :reports, only: :create
        resources :conversations, only: [:show, :index] do
          get :unread_message_count, on: :member
          get :read_messages, on: :member
        end
        resources :notifications, only: :index
        resources :messages, only: [:create, :destroy] do
          get :deleted, on: :collection
        end
        resources :contents, only: [:index, :destroy] do
          member do
            post :like
            post :dislike
          end
        end
        resources :invitations, only: :create
        resources :shares, only: :create do
          delete '/', to: 'shares#destroy', on: :collection
        end
      end

      namespace :web do
        resources :hash_tags, only: :index do
          get :autocomplete_hash_tags, on: :collection
        end
      end
    end
  end
end
