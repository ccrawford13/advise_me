require "rails_helper"

RSpec.describe Appointment, type: :model do
  it { should validate_presence_of :summary }
  it { should validate_presence_of :description }
end
