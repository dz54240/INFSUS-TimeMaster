# spec/requests/api/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{session.token}" } }
  let!(:session) { create(:session, user: user, expired_at: nil) }

  describe 'GET /api/users' do
    it 'returns list of users', :aggregate_failures do
      create_list(:user, 3)
      get '/api/users', headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_a(Hash)
    end

    it 'requires authentication' do
      get '/api/users'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/users/:id' do
    it 'shows a user', :aggregate_failures do
      get "/api/users/#{user.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_a(Hash)
    end
  end

  describe 'POST /api/users' do
    let(:valid_params) do
      {
        data: {
          email: 'new@example.com',
          password: 'password123',
          role: 'employee',
          first_name: 'Ana',
          last_name: 'Example',
          birth_date: '1990-01-01'
        }
      }
    end

    it 'creates a user', :aggregate_failures do
      post '/api/users', params: valid_params

      expect(response).to have_http_status(:ok).or have_http_status(:created)
      expect(JSON.parse(response.body)).to be_a(Hash)
    end

    it 'returns error for invalid data', :aggregate_failures do
      post '/api/users', params: { data: { email: '' } }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['errors']).not_to be_empty
    end
  end

  describe 'PATCH /api/users/:id' do
    let(:update_params) do
      {
        data: {
          first_name: 'Updated',
          last_name: 'Name',
          email: user.email,
          birth_date: user.birth_date,
          role: user.role,
          hourly_rate: user.hourly_rate
        }
      }
    end

    it 'updates a user', :aggregate_failures do
      patch "/api/users/#{user.id}", headers: headers, params: update_params

      expect(response).to have_http_status(:ok)
      expect(user.reload.first_name).to eq('Updated')
    end
  end

  describe 'DELETE /api/users/:id' do
    it 'deletes a user', :aggregate_failures do
      delete "/api/users/#{user.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(User.exists?(user.id)).to be_falsey
    end
  end
end
