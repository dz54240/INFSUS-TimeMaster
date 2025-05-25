# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    resource :sessions, only: [:create, :destroy]

    resources :users, except: [:new, :edit]

    resources :organizations, except: [:new, :edit]

    resources :invitations, only: [:index, :show, :create, :destroy]

    resources :employments, only: [:index, :show, :create, :destroy]

    resources :projects, except: [:new, :edit]

    resources :teams, except: [:new, :edit]

    resources :team_memberships, only: [:index, :show, :create, :destroy]

    resources :work_logs, except: [:new, :edit] do
      collection do
        get :info
      end
    end

    post 'reset', to: 'tests#reset' if Rails.env.test?
  end
end
