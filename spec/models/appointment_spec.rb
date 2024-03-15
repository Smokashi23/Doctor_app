require 'rails_helper'
RSpec.describe Appointment, type: :model do
  let(:user) { create(:user) }
  let(:slot) { create(:slot, user: user) }

  it "is valid with valid attributes" do
    appt = build(:appt, slot: slot, user: user)
    expect(appt).to be_valid
  end

  it "belongs to a slot" do
    appt = create(:appt, slot: slot, user: user)
    expect(appt.slot).to eq(slot)
  end

  it "belongs to a user" do
    appt = create(:appt, slot: slot, user: user)
    expect(appt.user).to eq(user)
  end
end
