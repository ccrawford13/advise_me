require "rails_helper"

RSpec.describe Note, type: :model do
  it { should validate_presence_of :date }
  it { should validate_presence_of :body }
end
