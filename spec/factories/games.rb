FactoryGirl.define do
  factory :game do
    sequence(:name) { |n| "Civilization #{n}" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support", "game_images", "beer_pong.png")) }

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
