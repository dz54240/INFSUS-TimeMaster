# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Teams API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/teams' do
    get 'Lists teams' do
      tags 'Teams'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'teams found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['team'] },
                attributes: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    organization_id: { type: :integer },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' }
                  }
                }
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

    post 'Creates a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              organization_id: { type: :integer }
            },
            required: ['name', 'organization_id']
          }
        }
      }

      response '201', 'team created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['team'] },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
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
        let(:team) do
          {
            data: {
              name: 'New Team',
              description: 'Team description',
              organization_id: organization.id
            }
          }
        end
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        let(:team) { { data: { name: 'New Team' } } }
        run_test!
      end

      response '403', 'forbidden - user is not an owner' do
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:team) { { data: { name: 'New Team' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:team) { { data: { description: 'Missing name' } } }
        run_test!
      end
    end
  end

  path '/api/teams/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true,
              description: 'Team ID'
    parameter name: 'Authorization', in: :header, type: :string,
              description: 'Bearer token for authentication'

    get 'Retrieves a team' do
      tags 'Teams'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'team found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['team'] },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                  organization_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:team) { create(:team, organization: organization) }
        let(:id) { team.id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not organization owner or team member' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '404', 'team not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end

    put 'Updates a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string }
            }
          }
        }
      }

      response '200', 'team updated' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['team'] },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                  organization_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:team) { create(:team, organization: organization) }
        let(:id) { team.id }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:team_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        let(:team_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '403', 'forbidden - not organization owner' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:team_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '404', 'team not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:team_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:organization) { create(:organization) }
        let(:team) { create(:team, organization: organization) }
        let(:id) { team.id }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:team_update) { { data: { name: '' } } }
        run_test!
      end
    end

    delete 'Deletes a team' do
      tags 'Teams'
      security [bearer_auth: []]

      response '204', 'team deleted' do
        let(:organization) { create(:organization) }
        let(:team) { create(:team, organization: organization) }
        let(:id) { team.id }
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

      response '404', 'team not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end
    end
  end
end
