FactoryGirl::define do
  factory :tenant do
    display_name { Faker::Company.name }
    twitter_id { Faker::Name.first_name }
    email      { Faker::Internet.safe_email }
  end
end