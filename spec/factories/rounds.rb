FactoryGirl.define do
  factory :round do
    tournament
    number { Faker::Number.between(0, 5) }

    trait :with_matches do
      transient do
        matches_count 2
      end

      after(:build) do |round, evaluator|
        played_after = round.tournament.started_at + 1
        round.matches << build_list(:match, evaluator.matches_count, played_after: played_after)
      end
    end
  end
end
