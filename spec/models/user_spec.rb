require 'rails_helper'
RSpec.describe User, type: :model do
  let!(:roles) { create_list(:role, 3) } 

  let(:valid_attributes) do
    {
      email: Faker::Internet.email,
      password: Faker::Internet.password(min_length: 8),
      role_id: roles.sample.id,
      age: Faker::Number.between(from: 1, to: 120)
    }
  end

  it "is valid with valid attributes" do
    user = build(:user, valid_attributes)
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = build(:user, email: nil, role_id: roles.sample.id)
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = build(:user, password: nil, role_id: roles.sample.id)
    expect(user).to_not be_valid
  end

  it "is not valid with a password less than 8 characters" do
    user = build(:user, password: Faker::Internet.password(min_length: 8, max_length: 20), role_id: roles.sample.id)
    expect(user).to be_valid
  end

  it "is not valid with a duplicate email" do
    existing_user = create(:user, email: 'test@example.com', role_id: roles.sample.id)
    user = build(:user, email: 'test@example.com', role_id: roles.sample.id)
    expect(user).to_not be_valid
  end

  it "is not valid without a role_id" do
    user = build(:user, role_id: nil)
    expect(user).to_not be_valid
  end

  it "belongs to a role" do
    user = create(:user, role_id: roles.sample.id)
    expect(user.role).to be_present
  end

 
end




