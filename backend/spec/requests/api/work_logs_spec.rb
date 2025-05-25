# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Work Logs API', swagger: true, type: :request do # rubocop:disable RSpec/EmptyExampleGroup
  path '/api/work_logs/info' do
    get 'Get work logs info' do
      tags 'Work Logs'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'work logs info retrieved' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              total_count: { type: :integer }
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
  end

  path '/api/work_logs' do
    get 'Lists work logs' do
      tags 'Work Logs'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      response '200', 'work logs found' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string, enum: ['work_log'] },
                attributes: {
                  type: :object,
                  properties: {
                    start_time: { type: :string, format: 'date-time' },
                    end_time: { type: :string, format: 'date-time' },
                    activity_type: { type: :string, enum: ['development', 'remote_work', 'vacation'] },
                    description: { type: :string },
                    cost: { type: :string, format: 'decimal' },
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
                    },
                    project: {
                      type: :object,
                      properties: {
                        data: {
                          type: :object,
                          properties: {
                            id: { type: :string },
                            type: { type: :string, enum: ['project'] }
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
                type: { type: :string, enum: ['user', 'project'] },
                attributes: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    first_name: { type: :string },
                    last_name: { type: :string },
                    role: { type: :string },
                    hourly_rate: { type: :string, format: 'decimal' },
                    name: { type: :string },
                    description: { type: :string },
                    start_date: { type: :string, format: 'date', nullable: true },
                    end_date: { type: :string, format: 'date', nullable: true },
                    total_hours_spent: { type: :number },
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

    post 'Creates a work log' do
      tags 'Work Logs'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: 'Authorization', in: :header, type: :string,
                description: 'Bearer token for authentication'

      parameter name: :work_log, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              start_time: { type: :string, format: 'date-time' },
              end_time: { type: :string, format: 'date-time' },
              activity_type: { type: :string, enum: ['development', 'remote_work', 'vacation'] },
              description: { type: :string },
              project_id: { type: :integer }
            },
            required: ['start_time', 'end_time', 'activity_type', 'project_id']
          }
        }
      }

      response '201', 'work log created' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['work_log'] },
              attributes: {
                type: :object,
                properties: {
                  start_time: { type: :string, format: 'date-time' },
                  end_time: { type: :string, format: 'date-time' },
                  activity_type: { type: :string, enum: ['development', 'remote_work', 'vacation'] },
                  description: { type: :string },
                  cost: { type: :string, format: 'decimal' },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:project) { create(:project) }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:work_log) do
          {
            data: {
              start_time: Time.current,
              end_time: Time.current + 2.hours,
              activity_type: 'development',
              description: 'Working on feature',
              project_id: project.id
            }
          }
        end
        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'Bearer invalid_token' }
        let(:work_log) { { data: { start_time: Time.current } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:authorization) { "Bearer #{generate_token}" }
        let(:work_log) { { data: { start_time: Time.current } } }
        run_test!
      end
    end
  end

  path '/api/work_logs/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true,
              description: 'Work Log ID'
    parameter name: 'Authorization', in: :header, type: :string,
              description: 'Bearer token for authentication'

    get 'Retrieves a work log' do
      tags 'Work Logs'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'work log found' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['work_log'] },
              attributes: {
                type: :object,
                properties: {
                  start_time: { type: :string, format: 'date-time' },
                  end_time: { type: :string, format: 'date-time' },
                  activity_type: { type: :string, enum: ['development', 'remote_work', 'vacation'] },
                  description: { type: :string },
                  cost: { type: :string, format: 'decimal' },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:work_log) { create(:work_log) }
        let(:id) { work_log.id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not organization owner or work log owner' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '404', 'work log not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end

    put 'Updates a work log' do
      tags 'Work Logs'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :work_log, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              start_time: { type: :string, format: 'date-time' },
              end_time: { type: :string, format: 'date-time' },
              activity_type: { type: :string, enum: ['development', 'remote_work', 'vacation'] },
              description: { type: :string }
            }
          }
        }
      }

      response '200', 'work log updated' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, enum: ['work_log'] },
              attributes: {
                type: :object,
                properties: {
                  start_time: { type: :string, format: 'date-time' },
                  end_time: { type: :string, format: 'date-time' },
                  activity_type: { type: :string, enum: ['development', 'remote_work', 'vacation'] },
                  description: { type: :string },
                  cost: { type: :string, format: 'decimal' },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:work_log) { create(:work_log) }
        let(:id) { work_log.id }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:work_log_update) { { data: { description: 'Updated description' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        let(:work_log_update) { { data: { description: 'Updated description' } } }
        run_test!
      end

      response '403', 'forbidden - not organization owner or work log owner' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:work_log_update) { { data: { description: 'Updated description' } } }
        run_test!
      end

      response '404', 'work log not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:work_log_update) { { data: { description: 'Updated description' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:work_log) { create(:work_log) }
        let(:id) { work_log.id }
        let(:authorization) { "Bearer #{generate_token}" }
        let(:work_log_update) { { data: { end_time: work_log.start_time } } }
        run_test!
      end
    end

    delete 'Deletes a work log' do
      tags 'Work Logs'
      security [bearer_auth: []]

      response '204', 'work log deleted' do
        let(:work_log) { create(:work_log) }
        let(:id) { work_log.id }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:authorization) { 'Bearer invalid_token' }
        run_test!
      end

      response '403', 'forbidden - not organization owner or work log owner' do
        let(:id) { 1 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end

      response '404', 'work log not found' do
        let(:id) { 999999 }
        let(:authorization) { "Bearer #{generate_token}" }
        run_test!
      end
    end
  end
end 