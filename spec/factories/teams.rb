FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{Faker::Team.creature} #{n}" }

    transient do
      members_count 4
    end

    after(:build) do |team, evaluator|
      team.user_teams << build_list(:user_team, evaluator.members_count, team: team, user: build(:user))
    end
  end
end
