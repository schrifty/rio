FactoryGirl::define do
  factory :customer do
    tenant
    display_name { Faker::Name.first_name }
  end
end