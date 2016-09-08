FactoryGirl.define do
  factory :match do
    game
    played_at { Faker::Time.between(1.year.ago, Time.zone.today, :all) }
    association :team_one, factory: :team_with_members
    association :team_two, factory: :team_with_members
    team_one_score { Faker::Number.between(0, 100) }
    team_two_score { Faker::Number.between(0, 100) }

    factory :ongoing_match do
      team_one_score { nil }
      team_two_score { nil }
    end
  end
end
