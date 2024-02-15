require 'rails_helper'

RSpec.describe Role, type: :model do
  it "is valid with valid attributes" do
    role = build(:role)
    expect(role).to be_valid
  end

  it "is not valid without a role_name" do
    role = build(:role, role_name: nil)
    expect(role).to_not be_valid
  end

  it "has many users" do
    role = create(:role)
    user1 = create(:user, role: role)
    user2 = create(:user, role: role)
    
    expect(role.users.count).to eq(2)
  end
end


