FactoryGirl::define do
  factory :invite do
    tenant
    recipient_email { Faker::Internet.safe_email }
  end
end