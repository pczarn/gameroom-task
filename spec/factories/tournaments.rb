FactoryGirl.define do
  factory :tournament do
    title { "Tournament #{Faker::Space.star_cluster}"  }
    number_of_teams { Faker::Number.between(2, 20) * 2 }
    started_at { Faker::Time.between(1.year.ago, 1.year.from_now, :all) }

    transient do
      members_count 4
    end

    after(:build) do |tournament, evaluator|
      if tournament.matches.empty?
        tournament.matches << build_list(:match, evaluator.number_of_teams / 2)
      end
    end

    factory :tournament_with_number_of_members do
      number_of_members_per_team { Faker::Number.between(1, 30) }

      after(:build) do |tournament, evaluator|
        teams = tournament.matches.flat_map { |match| [match.team_one, match.team_two] }
        teams.each do |team|
          team.members = build_list(:user, evaluator.number_of_members_per_team)
        end
      end
    end
  end
end
