require 'rails_helper'

RSpec.describe Slot, type: :model do
  let(:user) { create(:user) } 

  it "is valid with valid attributes" do
    slot = build(:slot, user: user)
    expect(slot).to be_valid
  end

  it "is not valid with duplicate available time, days, and user" do
    existing_slot = create(:slot, user: user) 
    slot = build(:slot, user: user, available_time: existing_slot.available_time, available_days: existing_slot.available_days)
    expect(slot).to_not be_valid
  end

  it "has one appointment" do
    slot = create(:slot, user: user)
    appt = create(:appt, slot: slot)
    expect(slot.appt).to eq(appt) 
  end
end

