FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }

    trait :completed do
      completed_at { Time.current }
    end
  end
end
