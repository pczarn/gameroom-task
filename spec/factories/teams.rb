FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{Faker::Team.creature} #{n}" }

    factory :team_with_members do
      transient do
        members_count 4
      end

      after(:create) do |team, evaluator|
        create_list(:user_team, evaluator.members_count, team: team)
      end
    end
  end
end
