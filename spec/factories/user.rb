FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "user_#{n}@gmail.com" }
    password { '123123' }
    password_confirmation { '123123' }
  end
end
