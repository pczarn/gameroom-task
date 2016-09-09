class Match < ApplicationRecord
  belongs_to :game
  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team
end
