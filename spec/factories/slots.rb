FactoryBot.define do
  factory :slot do
    available_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 30) }
    available_days { Faker::Date.between(from: Date.today, to: 1.week.from_now) }
    association :user
  end
end

