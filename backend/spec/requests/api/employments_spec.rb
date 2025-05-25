# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Employments API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/employments' do
    get 'Lists employments' do
      tags 'Employments'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'employments found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['employment'] },
                attributes: {
                  type: :object,
                  properties: {
                    organization_id: { type: :integer },
                    user_id: { type: :integer },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' }
                  }
                },
                relationships: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        data: {
                          type: :object,
                          properties: {
                            id: { type: :string },
                            type: { type: :string, enum: ['user'] }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          included: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['user'] },
                attributes: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    first_name: { type: :string },
                    last_name: { type: :string },
                    role: { type: :string },
                    hourly_rate: { type: :number, nullable: true },
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

    post 'Creates an employment' do
      tags 'Employments'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      parameter name: :employment, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              organization_token: { type: :string }
            },
            required: ['organization_token']
          }
        }
      }

      response '201', 'employment created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['employment'] },
              attributes: {
                type: :object,
                properties: {
                  organization_id: { type: :integer },
                  user_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              },
              relationships: {
                type: :object,
                properties: {
                  user: {
                    type: :object,
                    properties: {
                      data: {
                        type: :object,
                        properties: {
                          id: { type: :string },
                          type: { type: :string, enum: ['user'] }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          included: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['user'] },
                attributes: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    first_name: { type: :string },
                    last_name: { type: :string },
                    role: { type: :string },
                    hourly_rate: { type: :number, nullable: true },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' }
                  }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:invitation) { create(:invitation, organization: organization) }
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:employment) { { data: { organization_token: invitation.token } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        let(:employment) { { data: { organization_token: 'invalid_token' } } }
        run_test!
      end

      response '403', 'forbidden - user is not an employee' do
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:employment) { { data: { organization_token: 'valid_token' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:employment) { { data: { organization_token: nil } } }
        run_test!
      end
    end
  end

  path '/api/employments/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true,
              description: 'Employment ID'
    parameter name: 'Authorization', in: :header, type: :string,
              description: 'Bearer token for authentication'

    get 'Retrieves an employment' do
      tags 'Employments'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'employment found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['employment'] },
              attributes: {
                type: :object,
                properties: {
                  organization_id: { type: :integer },
                  user_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              },
              relationships: {
                type: :object,
                properties: {
                  user: {
                    type: :object,
                    properties: {
                      data: {
                        type: :object,
                        properties: {
                          id: { type: :string },
                          type: { type: :string, enum: ['user'] }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          included: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['user'] },
                attributes: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    first_name: { type: :string },
                    last_name: { type: :string },
                    role: { type: :string },
                    hourly_rate: { type: :number, nullable: true },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' }
                  }
                }
              }
            }
          }
        }

        let(:organization) { create(:organization) }
        let(:employment) { create(:employment, organization: organization) }
        let(:id) { employment.id }
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

      response '404', 'employment not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end
    end

    delete 'Deletes an employment' do
      tags 'Employments'
      security [bearer_auth: []]

      response '204', 'employment deleted' do
        let(:organization) { create(:organization) }
        let(:employment) { create(:employment, organization: organization) }
        let(:id) { employment.id }
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

      response '404', 'employment not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end
    end
  end
end
