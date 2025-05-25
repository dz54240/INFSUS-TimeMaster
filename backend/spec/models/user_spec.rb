# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'secure password' do
    it { is_expected.to have_secure_password }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_inclusion_of(:role).in_array(%w[owner employee]) }
    it { is_expected.to validate_numericality_of(:hourly_rate).is_greater_than_or_equal_to(0).allow_nil }

    context 'when email validation' do
      it 'validates uniqueness of email case insensitively', :aggregate_failures do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'TEST@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end

      it 'validates email format', :aggregate_failures do
        user = build(:user, email: 'invalid_email')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('is invalid')
      end
    end

    context 'when birth_date validation' do
      it 'is valid when birth_date is in the past' do
        user = build(:user, birth_date: 20.years.ago)
        expect(user).to be_valid
      end

      it 'is invalid when birth_date is in the future', :aggregate_failures do
        user = build(:user, birth_date: 1.day.from_now)
        expect(user).not_to be_valid
        expect(user.errors[:birth_date]).to include("can't be in the future")
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:employments).dependent(:destroy) }
    it { is_expected.to have_many(:work_logs).dependent(:destroy) }
    it { is_expected.to have_many(:projects).through(:work_logs) }
    it { is_expected.to have_many(:organizations).through(:employments) }
    it { is_expected.to have_many(:team_memberships).dependent(:destroy) }
    it { is_expected.to have_many(:teams).through(:team_memberships) }
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
    it { is_expected.to have_many(:owned_organizations).class_name('Organization').dependent(:destroy) }
  end
end
