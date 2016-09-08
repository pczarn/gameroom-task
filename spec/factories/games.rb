FactoryGirl.define do
  factory :game do
    sequence(:name) { |n| "Our Game #{n}" }

    factory :game_with_matches do
      transient do
        matches_count 4
      end

      after(:create) do |game, evaluator|
        create_list(:match, evaluator.matches_count, game: game)
      end
    end
  end
end
