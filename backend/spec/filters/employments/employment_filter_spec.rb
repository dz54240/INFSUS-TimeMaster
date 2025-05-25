# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employments::EmploymentFilter, type: :model do
  describe '#call' do
    subject(:filtered_result) { described_class.new(Employment.all, params).call }

    let!(:main_organization) { create(:organization) }
    let!(:other_organization) { create(:organization) }

    let!(:employment_in_main) { create(:employment, organization: main_organization) }
    let!(:employment_in_other) { create(:employment, organization: other_organization) }

    context 'when filtering by organization_id' do
      let(:params) { { organization_id: main_organization.id } }

      it 'returns employments for the specified organization' do
        expect(filtered_result).to contain_exactly(employment_in_main)
      end
    end

    context 'when no filters are provided' do
      let(:params) { {} }

      it 'returns all employments' do
        expect(filtered_result).to contain_exactly(employment_in_main, employment_in_other)
      end
    end

    context 'when organization_id does not match any employment' do
      let(:params) { { organization_id: 999_999 } }

      it 'returns an empty result' do
        expect(filtered_result).to be_empty
      end
    end
  end
end
