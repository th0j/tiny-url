class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email

  # attribute :created_date do |user|
  #   user && user.created_at.strftime('%d/%m/%Y')
  # end
end
