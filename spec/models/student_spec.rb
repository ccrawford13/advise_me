require 'rails_helper'

RSpec.describe Student, type: :model do
  it { should validate_presence_of :user }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :year }
  it { should validate_presence_of :major }
end
