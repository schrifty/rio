FactoryGirl::define do
  factory :tenant do
    twitter_id { Faker::Name.first_name }
    email      { Faker::Internet.safe_email }
  end
end