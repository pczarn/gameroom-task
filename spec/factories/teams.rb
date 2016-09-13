FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{Faker::Team.creature} #{n}" }

    transient do
      members_count 4
    end

    after(:build) do |team, evaluator|
      if team.members.empty?
        team.members << build_list(:user, evaluator.members_count)
      end
    end
  end
end
