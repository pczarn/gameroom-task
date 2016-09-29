FactoryGirl.define do
  factory :match do
    transient do
      played_after 1.year.ago
    end

    game
    played_at { Faker::Time.between(played_after, played_after + 1.year, :all) }
    association :team_one, factory: :team
    association :team_two, factory: :team
    team_one_score { Faker::Number.between(0, 100) }
    team_two_score { Faker::Number.between(0, 100) }

    trait :ongoing do
      team_one_score { nil }
      team_two_score { nil }
    end
  end
end
