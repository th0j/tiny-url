class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  include ActionController::MimeResponds
  respond_to :json

  private

  def respond_with(_resource, _opts = {})
    if resource.persisted?
      render json: {
        message: { code: 200, message: "Logged in sucessfully" },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
