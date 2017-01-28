require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create :user }

  its(:role) { is_expected.to eq 'customer' }

  describe 'with the same email' do
    subject(:user_with_same_email) { build :user, email: user.email }

    it { is_expected.not_to be_valid }
  end
end
