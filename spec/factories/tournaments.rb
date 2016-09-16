FactoryGirl.define do
  factory :tournament do
    title { "Tournament #{Faker::Space.star_cluster}"  }
    number_of_teams { 2**Faker::Number.between(1, 6) }
    started_at { Faker::Time.between(1.year.ago, 1.year.from_now, :all) }

    image do
      image_path = File.join(Rails.root, "spec", "support", "tournament_images", "mk.jpg")
      Rack::Test::UploadedFile.new(image_path)
    end

    transient do
      members_count 4
    end

    after(:build) do |tournament, evaluator|
      if tournament.teams.empty?
        tournament.teams << build_list(:team, evaluator.number_of_teams)
      end
    end
  end
end
