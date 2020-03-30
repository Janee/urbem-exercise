require 'rails_helper'

RSpec.describe Webhook, type: :model do
  hook = {
    data: {'some': 'json'},
    integration_name: 'test',
    event_id: 666
  }
  subject {
    described_class.new(hook)
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid if event exists" do
    Webhook.create!(hook)
    other = Webhook.new(event_id: 666)
    expect(other).not_to be_valid
    expect(other.errors[:event_id]).to include("has already been taken")
  end
end
