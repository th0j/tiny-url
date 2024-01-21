FactoryBot.define do
  factory :url, class: Url do
    association :user, factory: :user, strategy: :build

    original_url { Faker::Internet.url }
    slug { SecureRandom.alphanumeric(6) }
  end
end
