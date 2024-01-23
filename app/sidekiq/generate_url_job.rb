class GenerateUrlJob
  include Sidekiq::Job

  MAXIMUM_LOOP = 500
  def perform(url_id)
    @invalid_slug = []
    slug = build_slug
    url = Url.find_by(id: url_id)

    for _ in 0..MAXIMUM_LOOP
      break unless Url.exists?(slug)

      @invalid_slug << slug
      slug = build_slug
    end

    url.update!(slug: slug)
  end

  private

  def build_slug
    slug = ''

    for _ in 0..MAXIMUM_LOOP
      hex = SecureRandom.random_number(0..Url::MAXIMUM_HEX)
      slug = Base58.encode(hex)
      break unless @invalid_slug.include?(slug)
    end

    slug
  end
end
