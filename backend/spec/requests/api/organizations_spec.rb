# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Organizations API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/organizations' do
    get 'Lists organizations' do
      tags 'Organizations'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'organizations found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                description: { type: :string },
                established_at: { type: :string, format: 'date' },
                owner_id: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }
        }

        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    post 'Creates an organization' do
      tags 'Organizations'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      parameter name: :organization, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              established_at: { type: :string, format: 'date' }
            },
            required: ['name']
          }
        }
      }

      response '201', 'organization created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              established_at: { type: :string, format: 'date' },
              owner_id: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        }

        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:organization) { { data: { name: 'New Organization', description: 'Description', established_at: '2024-01-01' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        let(:organization) { { data: { name: 'New Organization' } } }
        run_test!
      end

      response '403', 'forbidden - user is not an owner' do
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:organization) { { data: { name: 'New Organization' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:organization) { { data: { description: 'Missing name' } } }
        run_test!
      end
    end
  end

  path '/api/organizations/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true,
              description: 'Organization ID'
    parameter name: 'Authorization', in: :header, type: :string,
              description: 'Bearer token for authentication'

    get 'Retrieves an organization' do
      tags 'Organizations'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'organization found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              established_at: { type: :string, format: 'date' },
              owner_id: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        }

        let(:id) { create(:organization).id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:organization).id }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not owner or employee' do
        let(:id) { create(:organization).id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '404', 'organization not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end

    put 'Updates an organization' do
      tags 'Organizations'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :organization, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              established_at: { type: :string, format: 'date' }
            }
          }
        }
      }

      response '200', 'organization updated' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              established_at: { type: :string, format: 'date' },
              owner_id: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        }

        let(:id) { create(:organization).id }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:organization) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:organization).id }
        let(:authorization) { 'Bearer invalid_token' }
        let(:organization) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '403', 'forbidden - not owner' do
        let(:id) { create(:organization).id }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:organization) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '404', 'organization not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:organization) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:organization).id }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:organization) { { data: { name: '' } } }
        run_test!
      end
    end

    delete 'Deletes an organization' do
      tags 'Organizations'
      security [bearer_auth: []]

      response '204', 'organization deleted' do
        let(:id) { create(:organization).id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:organization).id }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not owner' do
        let(:id) { create(:organization).id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '404', 'organization not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end
  end
end
