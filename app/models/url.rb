class Url < ApplicationRecord
  belongs_to :user

  validates :original_url, presence: true,
                           length: { maximum: 2_000_000, too_long: `%{count} characters is the maximum allowed` },
                           uniqueness: { scope: :user }
  validates :slug, length: { maximum: 6 }

  MAXIMUM_HEX = 38_068_692_543 # Magic number = 58^6 slugs = 38,068,692,543 from requirement

  # TODO: validate original_url is http request
end
