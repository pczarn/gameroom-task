PEOPLE = %w(
  Krzysztof
  Jan
  Dariusz
  Tomasz
  Mateusz
  Gilbert
  Jakub
  Zuzanna
  Wojciech
  Radek
  Daniel
  Michał
  Magdalena
  Kacper
  Kamila
  Damian
  Tobiasz
  Szymon
  Bartosz
).freeze

PASS = "password".freeze
PASS_HASHED = Argon2::Password.create(PASS)

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "#{Faker::Name.prefix} #{PEOPLE.sample} #{n}" }
    email { Faker::Internet.email }
    password PASS
    password_confirmation PASS
    password_hashed PASS_HASHED
  end
end
