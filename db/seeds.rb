# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

Match.destroy_all
Round.destroy_all
TeamTournament.destroy_all
Tournament.destroy_all
UserTeam.destroy_all
User.destroy_all
Team.destroy_all
Game.destroy_all

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
  User.create(name: "Pawel", email: "pawel@monterail.com", **pass_h),
  User.create(name: "Marcin", email: "marcin@monterail.com", **pass_h),
]

michal = users.first
admin = users[2]

michals = Team.create(name: "The Michals", members: users[0..1])
middle = Team.create(name: "The Middle", members: users[2..4])
daniel_team = Team.create(name: "Just Daniel", members: [users[5]])
emmanuel_team = Team.create(name: "Just Emmanuel", members: [users[6]])
internal = Team.create(name: "Internal", members: users[0..4])
qa = Team.create(name: "QA", members: users[7..8])

their_team = Team.create(
  name: "Their",
  members: [User.find_by(name: "Rafal"), User.find_by(name: "Michal the Second")],
)
our_team = Team.create(
  name: "Our",
  members: [User.find_by(name: "Piotr"), User.find_by(name: "Michal the First")],
)

# ongoing

Match.create(
  game: beer_pong,
  team_one: michals,
  team_two: middle,
  owner: michal,
)

# finished

first_match = Match.create(
  game: beer_pong,
  team_one: michals,
  team_two: daniel_team,
  team_one_score: 75,
  team_two_score: 52,
  played_at: "2016-10-01 18:12".to_time(:utc),
  owner: michal,
)
Match.create(
  game: beer_pong,
  team_one: middle,
  team_two: daniel_team,
  team_one_score: 77,
  team_two_score: 59,
  played_at: "2016-09-13 11:12".to_time(:utc),
  owner: michal,
)
Match.create(
  game: monte_kombat,
  team_one: michals,
  team_two: daniel_team,
  team_one_score: 8,
  team_two_score: 54,
  played_at: "2016-09-13 12:12".to_time(:utc),
  owner: michal,
)
Match.create(
  game: monte_kombat,
  team_one: michals,
  team_two: daniel_team,
  team_one_score: 7,
  team_two_score: 5,
  played_at: "2016-09-13 13:12".to_time(:utc),
  owner: michal,
)
Match.create(
  game: ufc,
  team_one: daniel_team,
  team_two: emmanuel_team,
  team_one_score: 22,
  team_two_score: 33,
  played_at: "2016-09-13 14:12".to_time(:utc),
  owner: michal,
)
Match.create(
  game: monte_kombat,
  team_one: our_team,
  team_two: their_team,
  team_one_score: 3,
  team_two_score: 0,
  played_at: "2016-10-24 13:00".to_time(:utc),
  owner: michal,
)
Match.create(
  game: monte_kombat,
  team_one: our_team,
  team_two: their_team,
  team_one_score: 22,
  team_two_score: 33,
  played_at: "2016-10-25 13:00".to_time(:utc),
  owner: michal,
)
Match.create(
  game: monte_kombat,
  team_one: our_team,
  team_two: their_team,
  team_one_score: nil,
  team_two_score: nil,
  played_at: "2016-10-26 13:00".to_time(:utc),
  owner: michal,
)
ufc_ended_rounds = [
  [
    Match.create(
      game: ufc,
      team_one: michals,
      team_two: middle,
      team_one_score: 1000,
      team_two_score: 9,
      played_at: "2016-09-18 14:12".to_time(:utc),
    ),
  ],
]
ufc_september_rounds = [
  [
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
  ],
  [
    Match.create(
      game: ufc,
      team_one: michals,
      team_two: emmanuel_team,
      played_at: "2016-09-22 14:12".to_time(:utc),
    ),
  ],
]
ufc_october_rounds = [
  [
    Match.create(
      game: ufc,
      team_one: internal,
      team_two: qa,
      team_one_score: 0,
      team_two_score: 11,
      played_at: "2016-10-22 14:12".to_time(:utc),
    ),
    Match.create(
      game: ufc,
      team_one: emmanuel_team,
      team_two: daniel_team,
      played_at: "2016-10-22 14:12".to_time(:utc),
    ),
  ],
  [],
]

# open

Tournament.create(
  title: "first open one",
  description: "we play montal kombat",
  game: monte_kombat,
  owner: admin,
  number_of_teams: 4,
  started_at: "2016-09-01 18:12".to_time(:utc),
  teams: [michals, middle, daniel_team, emmanuel_team],
)
Tournament.create(
  title: "beer championship 2017",
  game: beer_pong,
  owner: admin,
  number_of_teams: 2,
  started_at: "2017-09-01 18:12".to_time(:utc),
  teams: [michals, middle],
)

# started

current_championship = Tournament.create(
  title: "beer championship 2016",
  game: beer_pong,
  owner: admin,
  status: 1,
  number_of_teams: 2,
  started_at: "2016-09-02 18:12".to_time(:utc),
  teams: [michals, daniel_team],
)

ufc_september = Tournament.create(
  title: "ufc tournament september",
  game: ufc,
  owner: michal,
  status: 1,
  number_of_teams: 4,
  started_at: "2016-09-03 18:12".to_time(:utc),
  teams: [michals, middle, daniel_team, emmanuel_team],
)

ufc_october = Tournament.create(
  title: "ufc tournament october",
  game: ufc,
  owner: users.first,
  status: 1,
  number_of_teams: 4,
  started_at: "2016-10-03 18:12".to_time(:utc),
  teams: [internal, qa, daniel_team, emmanuel_team],
)

# ended

ufc_ended = Tournament.create(
  title: "ufc tournament august",
  game: ufc,
  owner: admin,
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

######

Round.create(
  tournament: ufc_ended,
  matches: ufc_ended_rounds[0],
  number: 0,
)

######

Round.create(
  tournament: ufc_september,
  matches: ufc_september_rounds[0],
  number: 0,
)

Round.create(
  tournament: ufc_september,
  matches: ufc_september_rounds[1],
  number: 1,
)

######

Round.create(
  tournament: ufc_october,
  matches: ufc_october_rounds[0],
  number: 0,
)

Round.create(
  tournament: ufc_october,
  matches: ufc_october_rounds[1],
  number: 1,
)
