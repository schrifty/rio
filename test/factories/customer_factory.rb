FactoryGirl::define do
  factory :customer do
    tenant
    display_name { Faker::Company.name }
  end
end