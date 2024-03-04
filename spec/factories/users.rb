FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    age {Faker::Number.between(from: 1, to: 120)}
    role

    trait :admin do
      after(:create) do |user|
        user.role = create(:role, role_name: 'admin')
      end  
    end
    trait :doctor do
      role { create(:role, role_name: 'Doctor') }
    end

    trait :patient do
      role { create(:role, role_name: 'Patient') }
    end
  end
end
