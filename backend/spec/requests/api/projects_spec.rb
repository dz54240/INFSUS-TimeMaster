# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Projects API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/projects' do
    get 'Lists projects' do
      tags 'Projects'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'projects found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['project'] },
                attributes: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    start_date: { type: :string, format: 'date' },
                    end_date: { type: :string, format: 'date' },
                    budget_amount: { type: :number },
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

    post 'Creates a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              start_date: { type: :string, format: 'date' },
              end_date: { type: :string, format: 'date' },
              budget_amount: { type: :number },
              organization_id: { type: :integer }
            },
            required: ['name', 'organization_id']
          }
        }
      }

      response '201', 'project created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['project'] },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                  start_date: { type: :string, format: 'date' },
                  end_date: { type: :string, format: 'date' },
                  budget_amount: { type: :number },
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
        let(:project) do
          {
            data: {
              name: 'New Project',
              description: 'Project description',
              start_date: '2024-01-01',
              end_date: '2024-12-31',
              budget_amount: 10000.00,
              organization_id: organization.id
            }
          }
        end
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        let(:project) { { data: { name: 'New Project' } } }
        run_test!
      end

      response '403', 'forbidden - user is not an owner' do
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:project) { { data: { name: 'New Project' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:project) { { data: { description: 'Missing name' } } }
        run_test!
      end
    end
  end

  path '/api/projects/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true,
              description: 'Project ID'
    parameter name: 'Authorization', in: :header, type: :string,
              description: 'Bearer token for authentication'

    get 'Retrieves a project' do
      tags 'Projects'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'project found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['project'] },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                  start_date: { type: :string, format: 'date' },
                  end_date: { type: :string, format: 'date' },
                  budget_amount: { type: :number },
                  organization_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:project) { create(:project, organization: organization) }
        let(:id) { project.id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not organization owner or employee' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '404', 'project not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end

    put 'Updates a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              start_date: { type: :string, format: 'date' },
              end_date: { type: :string, format: 'date' },
              budget_amount: { type: :number }
            }
          }
        }
      }

      response '200', 'project updated' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['project'] },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                  start_date: { type: :string, format: 'date' },
                  end_date: { type: :string, format: 'date' },
                  budget_amount: { type: :number },
                  organization_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:project) { create(:project, organization: organization) }
        let(:id) { project.id }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:project_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        let(:project_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '403', 'forbidden - not organization owner' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:project_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '404', 'project not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:project_update) { { data: { name: 'Updated Name' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:organization) { create(:organization) }
        let(:project) { create(:project, organization: organization) }
        let(:id) { project.id }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:project_update) { { data: { name: '' } } }
        run_test!
      end
    end

    delete 'Deletes a project' do
      tags 'Projects'
      security [bearer_auth: []]

      response '204', 'project deleted' do
        let(:organization) { create(:organization) }
        let(:project) { create(:project, organization: organization) }
        let(:id) { project.id }
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

      response '404', 'project not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end
    end
  end
end
