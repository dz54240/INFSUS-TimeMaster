# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employments::EmploymentService, type: :service do
  subject(:service_call) { described_class.new(record, params, user).perform }

  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:invitation) { create(:invitation, organization: organization, token_used: false) }
  let(:params) { { organization_token: invitation.token } }
  let(:record) { Employment.new }

  context 'when invitation token is valid' do
    it 'creates an employment', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      result = service_call

      expect(result).to be_success
      expect(result.data).to be_a(Employment)
      expect(result.data.user).to eq(user)
      expect(result.data.organization).to eq(organization)
      expect(invitation.reload.token_used).to eq(true)
    end
  end

  context 'when invitation token is missing' do
    let(:params) { { organization_token: nil } }

    it 'fails with invalid token error', :aggregate_failures do
      result = service_call

      expect(result).to be_failure
      expect(result.errors).to include('Organization token is invalid')
    end
  end

  context 'when invitation token is already used' do
    it 'fails with invalid token error', :aggregate_failures do
      used_invitation = create(:invitation, organization: organization, token_used: true)
      params = { organization_token: used_invitation.token }

      result = described_class.new(Employment.new, params, user).perform

      expect(result).to be_failure
      expect(result.errors).to include('Organization token is invalid')
    end
  end


  context 'when user is already employed by the organization' do
    before do
      create(:employment, user: user, organization: organization)
    end

    it 'fails with uniqueness validation error', :aggregate_failures do
      result = service_call

      expect(result).to be_failure
      expect(result.errors).to include('User is already employed by this organization')
    end
  end
end
