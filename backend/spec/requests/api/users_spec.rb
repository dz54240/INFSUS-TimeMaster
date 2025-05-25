# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/users' do
    get 'Lists users' do
      tags 'Users'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'users found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                first_name: { type: :string },
                last_name: { type: :string },
                role: { type: :string }
              }
            }
          }
        }

        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end

    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              role: { type: :string, enum: ['owner', 'employee'] }
            },
            required: ['email', 'password']
          }
        }
      }

      response '201', 'user created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              role: { type: :string }
            }
          }
        }

        let(:user) { { data: { email: 'new@example.com', password: 'password123' } } }
        run_test!
      end
    end
  end

  path '/api/users/{id}' do
    parameter name: 'id', in: :path, type: :integer

    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'user found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              role: { type: :string }
            }
          }
        }

        let(:id) { create(:user).id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :id, in: :path, type: :integer, required: true,
                description: 'ID of the user to delete'
      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '204', 'user deleted' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:authorization) { 'Bearer token' }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:authorization) { 'Bearer token' }

        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 999999 }
        let(:authorization) { 'Bearer token' }

        run_test!
      end
    end
  end
end
