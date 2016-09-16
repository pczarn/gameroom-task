FactoryGirl.define do
  factory :round do
    tournament
    number { Faker::Number.between(0, 5) }

    transient do
      matches_count 4
    end

    after(:build) do |round, evaluator|
      if round.matches.empty?
        round.matches << build_list(:match, evaluator.matches_count)
      end
    end
  end
end
