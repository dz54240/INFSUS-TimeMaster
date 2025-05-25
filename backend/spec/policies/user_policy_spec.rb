# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject(:policy) { described_class.new(user, record) }

  let(:owner) { create(:user, :owner) }
  let(:organization) { create(:organization, owner:) }
  let(:user) { owner }
  let(:record) { create(:user) }

  describe 'index?' do
    it 'allows access to all users', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      employee = create(:user, role: 'employee')
      other_user = create(:user)
      target_user = create(:user)

      expect(described_class.new(owner, target_user).index?).to be true
      expect(described_class.new(employee, target_user).index?).to be true
      expect(described_class.new(other_user, target_user).index?).to be true
    end
  end

  describe 'show?' do
    it 'allows users to view their own profile', :aggregate_failures do
      employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)

      expect(described_class.new(owner, owner).show?).to be true
      expect(described_class.new(employee, employee).show?).to be true
    end

    it 'allows organization owners to view their employees' do
      employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)

      expect(described_class.new(owner, employee).show?).to be true
    end

    it 'denies access to other users', :aggregate_failures do
      employee = create(:user, role: 'employee')
      other_user = create(:user)
      create(:employment, user: employee, organization:)

      expect(described_class.new(employee, other_user).show?).to be false
      expect(described_class.new(other_user, employee).show?).to be false
    end
  end

  describe 'create?' do
    it 'allows access to all users', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      employee = create(:user, role: 'employee')
      other_user = create(:user)
      target_user = create(:user)

      expect(described_class.new(owner, target_user).create?).to be true
      expect(described_class.new(employee, target_user).create?).to be true
      expect(described_class.new(other_user, target_user).create?).to be true
    end
  end

  describe 'update?' do
    it 'allows users to update their own profile', :aggregate_failures do
      employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)

      expect(described_class.new(owner, owner).update?).to be true
      expect(described_class.new(employee, employee).update?).to be true
    end

    it 'allows organization owners to update their employees' do
      employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)

      expect(described_class.new(owner, employee).update?).to be true
    end

    it 'denies access to other users', :aggregate_failures do
      employee = create(:user, role: 'employee')
      other_user = create(:user)
      create(:employment, user: employee, organization:)

      expect(described_class.new(employee, other_user).update?).to be false
      expect(described_class.new(other_user, employee).update?).to be false
    end
  end

  describe 'destroy?' do
    it 'allows users to delete their own profile', :aggregate_failures do
      employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)

      expect(described_class.new(owner, owner).destroy?).to be true
      expect(described_class.new(employee, employee).destroy?).to be true
    end

    it 'denies access to other users', :aggregate_failures do
      employee = create(:user, role: 'employee')
      other_user = create(:user)
      create(:employment, user: employee, organization:)

      expect(described_class.new(owner, employee).destroy?).to be false
      expect(described_class.new(employee, other_user).destroy?).to be false
    end
  end

  describe '#permitted_attributes_for_create' do
    it 'returns the correct attributes for all users' do
      attributes = [:first_name, :last_name, :email, :password, :birth_date, :role]
      expect(policy.permitted_attributes_for_create).to match_array(attributes)
    end
  end

  describe '#permitted_attributes_for_update' do
    it 'returns only hourly_rate when owner updates employee' do
      employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)
      policy = described_class.new(owner, employee)

      expect(policy.permitted_attributes_for_update).to contain_exactly(:hourly_rate)
    end

    it 'returns all permitted attributes when owner updates themselves' do
      attributes = [:first_name, :last_name, :email, :birth_date, :hourly_rate]
      policy = described_class.new(owner, owner)

      expect(policy.permitted_attributes_for_update).to match_array(attributes)
    end

    it 'returns basic attributes when employee updates themselves' do
      employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)
      policy = described_class.new(employee, employee)

      attributes = [:first_name, :last_name, :email, :birth_date]
      expect(policy.permitted_attributes_for_update).to match_array(attributes)
    end
  end

  describe 'Scope' do
    it 'shows only organization employees and self when employee', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      employee = create(:user, role: 'employee')
      other_organization = create(:organization)
      other_employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)
      create(:employment, user: other_employee, organization: other_organization)

      scope = UserPolicy::Scope.new(employee, User).resolve
      expect(scope).to include(employee)
      expect(scope).not_to include(other_employee, owner)
    end

    it 'shows all organization members and self for owners', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      employee = create(:user, role: 'employee')
      other_organization = create(:organization)
      other_employee = create(:user, role: 'employee')
      create(:employment, user: employee, organization:)
      create(:employment, user: other_employee, organization: other_organization)

      scope = UserPolicy::Scope.new(owner, User).resolve
      expect(scope).to include(owner, employee)
      expect(scope).not_to include(other_employee)
    end
  end
end
