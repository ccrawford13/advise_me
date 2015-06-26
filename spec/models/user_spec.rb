require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :position }
  it { should validate_presence_of :organization }

  describe '#full_name' do
    it 'returns full name' do
      user = build(:user, first_name: 'Bill', last_name: 'Advisor')
      expect(user.full_name).to eq 'Bill Advisor'
    end
  end
end
