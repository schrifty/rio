FactoryGirl::define do
  factory :message do
    tenant
    conversation
    agent
    text { Faker::Lorem.sentence }
  end
end