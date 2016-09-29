FactoryGirl.define do
  factory :game do
    sequence(:name) { |n| "Civilization #{n}" }

    trait :with_image do
      image do
        image_path = File.join(Rails.root, "spec", "support", "game_images", "beer_pong.png")
        Rack::Test::UploadedFile.new(image_path)
      end
    end

    trait :with_matches do
      transient do
        matches_count 4
      end

      after(:create) do |game, evaluator|
        create_list(:match, evaluator.matches_count, game: game)
      end
    end
  end
end
