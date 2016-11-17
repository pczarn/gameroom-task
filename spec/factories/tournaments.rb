FactoryGirl.define do
  factory :tournament do
    transient do
      number_of_rounds { Faker::Number.between(1, 3) }
    end

    title { |n| "Tournament #{Faker::Space.star_cluster} #{n}" }
    game
    association :owner, factory: :user
    number_of_teams { 2**number_of_rounds }
    started_at { Faker::Time.between(1.year.ago, 1.year.from_now, :all) }

    trait :with_teams do
      after(:build) do |tournament, evaluator|
        tournament.teams << build_list(:team, evaluator.number_of_teams)
      end
    end

    trait :with_rounds do
      after(:build) do |tournament, evaluator|
        evaluator.number_of_rounds.times do |i|
          tournament.rounds << build(:round, :with_matches, tournament: tournament, number: i)
        end
      end
    end

    trait :with_image do
      image do
        image_path = File.join(Rails.root, "spec", "support", "tournament_images", "mk.jpg")
        Rack::Test::UploadedFile.new(image_path)
      end
    end
  end
end
