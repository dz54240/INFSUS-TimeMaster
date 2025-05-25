# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Invitations API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/invitations' do
    get 'Lists invitations' do
      tags 'Invitations'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'invitations found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['invitation'] },
                attributes: {
                  type: :object,
                  properties: {
                    token: { type: :string },
                    token_used: { type: :boolean },
                    organization_id: { type: :integer },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' }
                  }
                }
              }
            }
          }
        }

        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - user is not an owner' do
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        run_test!
      end
    end

    post 'Creates an invitation' do
      tags 'Invitations'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      parameter name: :invitation, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              organization_id: { type: :integer }
            },
            required: ['organization_id']
          }
        }
      }

      response '201', 'invitation created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['invitation'] },
              attributes: {
                type: :object,
                properties: {
                  token: { type: :string },
                  token_used: { type: :boolean },
                  organization_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:invitation) { { data: { organization_id: organization.id } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        let(:invitation) { { data: { organization_id: 1 } } }
        run_test!
      end

      response '403', 'forbidden - user is not an owner' do
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:invitation) { { data: { organization_id: 1 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:invitation) { { data: { organization_id: nil } } }
        run_test!
      end
    end
  end

  path '/api/invitations/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true,
              description: 'Invitation ID'
    parameter name: 'Authorization', in: :header, type: :string,
              description: 'Bearer token for authentication'

    get 'Retrieves an invitation' do
      tags 'Invitations'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'invitation found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['invitation'] },
              attributes: {
                type: :object,
                properties: {
                  token: { type: :string },
                  token_used: { type: :boolean },
                  organization_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:invitation) { create(:invitation, organization: organization) }
        let(:id) { invitation.id }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not organization owner' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        run_test!
      end

      response '404', 'invitation not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end
    end

    delete 'Deletes an invitation' do
      tags 'Invitations'
      security [bearer_auth: []]

      response '204', 'invitation deleted' do
        let(:organization) { create(:organization) }
        let(:invitation) { create(:invitation, organization: organization) }
        let(:id) { invitation.id }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not organization owner' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        run_test!
      end

      response '404', 'invitation not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end
    end
  end
end 