# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  describe '#serializable_hash' do
    subject(:serialized) do
      JSON.parse(described_class.new(user).serializable_hash.to_json)['data']['attributes']
    end

    let(:user) do
      create(:user,
             email: 'test@example.com',
             first_name: 'Test',
             last_name: 'User',
             role: 'employee',
             hourly_rate: 50.0)
    end

    it 'includes expected attributes' do # rubocop:disable RSpec/ExampleLength
      expect(serialized).to include(
        'email' => 'test@example.com',
        'first_name' => 'Test',
        'last_name' => 'User',
        'role' => 'employee',
        'hourly_rate' => '50.0',
        'created_at' => user.created_at.iso8601(3),
        'updated_at' => user.updated_at.iso8601(3)
      )
    end

    it 'does not include unexpected attributes' do
      expect(serialized.keys).to match_array(
        %w[email first_name last_name role hourly_rate created_at updated_at]
      )
    end
  end
end
