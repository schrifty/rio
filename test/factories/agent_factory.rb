FactoryGirl::define do
  factory :agent do
    tenant
    available           { rand(3) }
    engaged             0
    email               { Faker::Internet.safe_email }
    display_name        { Faker::Name.first_name }
    password            { Faker::Lorem.characters(12) }
    xid                 { Faker::Lorem.characters(20) }
    admin               0
  end
end