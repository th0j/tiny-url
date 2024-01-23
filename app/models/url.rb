class Url < ApplicationRecord
  belongs_to :user

  validates :original_url, presence: true,
                           length: { maximum: 2_000_000, too_long: `%{count} characters is the maximum allowed` },
                           uniqueness: { scope: :user }
  validates :original_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :slug, length: { maximum: 6 }
  MAXIMUM_HEX = 38_068_692_543 # Magic number = 58^6 slugs = 38,068,692,543 from requirement

  def self.popular(slug)
    Rails.cache.fetch("popular_urls_#{slug}", expires_in: 1.day) do
      find_by(slug:)
    end
  end
end
