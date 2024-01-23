class CreateUrlService
  attr_reader :url

  MAXIMUM_LOOP = 500
  def initialize(tiny_url_params, current_user)
    @tiny_url_params = tiny_url_params
    @current_user =  current_user
  end

  # ensure slug is unique, re-roll if it is not
  def call
    @url = @current_user.urls.find_by(original_url: @tiny_url_params[:original_url])
    return true if url

    @url = @current_user.urls.create!(@tiny_url_params)
    hex = @url.id.split('-').first.hex
    hex -= SecureRandom.random_number(0..Url::MAXIMUM_HEX) while hex > Url::MAXIMUM_HEX
    slug = build_slug(hex)

    for _ in 0..MAXIMUM_LOOP do
      break unless Url.exists?(slug)

      slug = build_slug(hex)
    end

    @url.update(slug:)
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_slug(hex)
    hex -= SecureRandom.random_number(0..Url::MAXIMUM_HEX)
    hex -= SecureRandom.random_number(0..Url::MAXIMUM_HEX) while hex > Url::MAXIMUM_HEX
    Base58.encode(hex.abs)
  end
end
