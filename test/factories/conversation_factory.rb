FactoryGirl::define do
  factory :conversation do
    tenant
    resolved            0
    customer
    referer_url         { Faker::Internet.url }
    location            { Faker::Address.city }
  end
end