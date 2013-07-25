FactoryGirl::define do
  factory :conversation do
    tenant
    active              1
    customer
    referer_url         { Faker::Internet.url }
    location            { Faker::Address.city }
  end
end