FactoryBot.define do
  factory :appointment do
    slot
    user
    trait :admin do
      role { create(:role, role_name: 'admin') } 
    end
  end
end
