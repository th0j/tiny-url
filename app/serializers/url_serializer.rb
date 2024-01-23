class UrlSerializer < BaseSerializer
  attributes :original_url, :slug

  attribute :status do |object|
    object.slug.blank? ? 'processing' : 'completed'
  end
end
