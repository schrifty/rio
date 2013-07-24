FactoryGirl::define do
  factory :message do
    tenant
    conversation
    agent
    text { Faker::Lorem.sentences(2) }
  end
end