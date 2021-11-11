FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@getnada.com" }
    password { '123456' }
  end
end
