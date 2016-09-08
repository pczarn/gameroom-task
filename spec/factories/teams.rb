FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{Faker::Team.creature} #{n}" }

    # can there be 'empty_team' instead?
    factory :team_with_members do
      transient do
        players_count 4
      end

      after(:create) do |team, evaluator|
        create_list(:user_team, evaluator.players_count, team: team)
      end
    end
  end
end
