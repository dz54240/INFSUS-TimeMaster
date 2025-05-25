# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Sessions API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/session' do
    post 'Creates a session' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '201', 'session created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              token: { type: :string },
              user: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  email: { type: :string },
                  role: { type: :string }
                }
              }
            }
          }
        }

        let(:params) { { email: 'user@example.com', password: 'password123' } }
        run_test!
      end

      response '400', 'invalid credentials' do
        schema type: :object, properties: {
          errors: {
            type: :array,
            items: { type: :string }
          }
        }

        let(:params) { { email: 'wrong@example.com', password: 'wrong' } }
        run_test!
      end
    end

    delete 'Destroys a session' do
      tags 'Sessions'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '204', 'session destroyed' do
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end
end
