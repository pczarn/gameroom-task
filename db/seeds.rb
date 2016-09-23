# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

monte_kombat = Game.create(name: "Monte Kombat")
beer_pong = Game.create(name: "Beer Pong")
ufc = Game.create(name: "UFC")

pass = Argon2::Password.create("hunter2")
pass_h = { password: pass, password_hashed: pass }

users = [
  User.create(name: "Michal the First", email: "m1@monterail.com", **pass_h),
  User.create(name: "Michal the Second", email: "m2@monterail.com", **pass_h),
  User.create(name: "Piotr", email: "p@monterail.com", **pass_h, role: 1),
  User.create(name: "Igor", email: "i@monterail.com", **pass_h),
  User.create(name: "Rafal", email: "r@monterail.com", **pass_h),
  User.create(name: "Daniel", email: "d@monterail.com", **pass_h),
  User.create(name: "Emmanuel", email: "e@monterail.com", **pass_h),
]

michals = Team.create(name: "The Michals", members: users[0..1])
middle = Team.create(name: "The Middle", members: users[2..4])
daniel_team = Team.create(name: "Just Daniel", members: [users[5]])
emmanuel_team = Team.create(name: "Just Emmanuel", members: [users[6]])
internal = Team.create(name: "Internal", members: users[0..4])

[michals, middle, daniel_team, emmanuel_team, internal].each do |team|
  team.user_teams.first.owner!
  team.save!
end

# ongoing

Match.create(
  game: beer_pong,
  team_one: michals,
  team_two: middle,
)

# finished

first_match = Match.create(
  game: beer_pong,
  team_one: michals,
  team_two: daniel_team,
  team_one_score: 75,
  team_two_score: 52,
  played_at: "2016-09-01 18:12".to_time(:utc),
)
Match.create(
  game: beer_pong,
  team_one: middle,
  team_two: daniel_team,
  team_one_score: 77,
  team_two_score: 59,
  played_at: "2016-09-13 11:12".to_time(:utc),
)
Match.create(
  game: monte_kombat,
  team_one: michals,
  team_two: daniel_team,
  team_one_score: 8,
  team_two_score: 54,
  played_at: "2016-09-13 12:12".to_time(:utc),
)
Match.create(
  game: monte_kombat,
  team_one: michals,
  team_two: daniel_team,
  team_one_score: 7,
  team_two_score: 5,
  played_at: "2016-09-13 13:12".to_time(:utc),
)
Match.create(
  game: ufc,
  team_one: daniel_team,
  team_two: emmanuel_team,
  team_one_score: 22,
  team_two_score: 33,
  played_at: "2016-09-13 14:12".to_time(:utc),
)
ufc_round_0_matches = [
  Match.create(
    game: ufc,
    team_one: michals,
    team_two: middle,
    team_one_score: 44,
    team_two_score: 12,
    played_at: "2016-09-18 14:12".to_time(:utc),
  ),
  Match.create(
    game: ufc,
    team_one: daniel_team,
    team_two: emmanuel_team,
    team_one_score: 0,
    team_two_score: 2,
    played_at: "2016-09-20 14:12".to_time(:utc),
  ),
]
ufc_round_1_matches = [
  Match.create(
    game: ufc,
    team_one: michals,
    team_two: emmanuel_team,
    team_one_score: 44,
    team_two_score: 12,
    played_at: "2016-09-22 14:12".to_time(:utc),
  ),
]

# open

Tournament.create(
  title: "first open one",
  description: "we play montal kombat",
  game: monte_kombat,
  owner: users.first,
  number_of_teams: 4,
  started_at: "2016-09-01 18:12".to_time(:utc),
  teams: [michals, middle, daniel_team, emmanuel_team],
)
Tournament.create(
  title: "beer championship 2017",
  game: beer_pong,
  owner: users.first,
  number_of_teams: 2,
  started_at: "2017-09-01 18:12".to_time(:utc),
  teams: [michals, middle],
)

# started

current_championship = Tournament.create(
  title: "beer championship 2016",
  game: beer_pong,
  owner: users.first,
  status: 1,
  number_of_teams: 2,
  started_at: "2016-09-02 18:12".to_time(:utc),
  teams: [michals, daniel_team],
)

ufc_september = Tournament.create(
  title: "ufc tournament september",
  game: ufc,
  owner: users.first,
  status: 1,
  number_of_teams: 4,
  started_at: "2016-09-03 18:12".to_time(:utc),
  teams: [michals, middle, daniel_team, emmanuel_team],
)

# ended

Tournament.create(
  title: "ufc tournament august",
  game: ufc,
  owner: users.first,
  status: 2,
  number_of_teams: 2,
  started_at: "2016-08-03 18:12".to_time(:utc),
  teams: [michals, middle],
)

# rounds

Round.create(
  tournament: current_championship,
  matches: [first_match],
  number: 0,
)

Round.create(
  tournament: ufc_september,
  matches: ufc_round_1_matches,
  number: 1,
)
