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

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "#{Faker::Name.prefix} #{PEOPLE.sample} #{n}" }
    email { Faker::Internet.email }
    password { Faker::Internet.password(7, 10) }
  end
end
