module AuthHelpers
  def generate_token
    user = create(:user)
    session = create(:session, user: user)
    session.token
  end

  def generate_token_for_other_user
    other_user = create(:user)
    session = create(:session, user: other_user)
    session.token
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end 