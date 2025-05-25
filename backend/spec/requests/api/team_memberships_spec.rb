# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Team Memberships API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/team_memberships' do
    get 'Lists team memberships' do
      tags 'Team Memberships'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'team memberships found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['team_membership'] },
                attributes: {
                  type: :object,
                  properties: {
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

        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    post 'Creates a team membership' do
      tags 'Team Memberships'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      parameter name: :team_membership, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              team_id: { type: :integer }
            },
            required: ['user_id', 'team_id']
          }
        }
      }

      response '201', 'team membership created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['team_membership'] },
              attributes: {
                type: :object,
                properties: {
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
        let(:team) { create(:team, organization: organization) }
        let(:user) { create(:user) }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:team_membership) do
          {
            data: {
              user_id: user.id,
              team_id: team.id
            }
          }
        end
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        let(:team_membership) { { data: { user_id: 1, team_id: 1 } } }
        run_test!
      end

      response '403', 'forbidden - user is not an owner' do
        let(:authorization) { "Bearer #{generate_token(role: 'employee')}" }
        let(:team_membership) { { data: { user_id: 1, team_id: 1 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        let(:team_membership) { { data: { user_id: 1 } } }
        run_test!
      end
    end
  end

  path '/api/team_memberships/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true,
              description: 'Team Membership ID'
    parameter name: 'Authorization', in: :header, type: :string,
              description: 'Bearer token for authentication'

    get 'Retrieves a team membership' do
      tags 'Team Memberships'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'team membership found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['team_membership'] },
              attributes: {
                type: :object,
                properties: {
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
        let(:team) { create(:team, organization: organization) }
        let(:user) { create(:user) }
        let(:team_membership) { create(:team_membership, team: team, user: user) }
        let(:id) { team_membership.id }
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

      response '404', 'team membership not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end

    delete 'Deletes a team membership' do
      tags 'Team Memberships'
      security [bearer_auth: []]

      response '204', 'team membership deleted' do
        let(:organization) { create(:organization) }
        let(:team) { create(:team, organization: organization) }
        let(:user) { create(:user) }
        let(:team_membership) { create(:team_membership, team: team, user: user) }
        let(:id) { team_membership.id }
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

      response '404', 'team membership not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token(role: 'owner')}" }
        run_test!
      end
    end
  end
end
