class Api::V1::Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  include ActionController::MimeResponds
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      # status: { code: 200, message: "Logged in sucessfully" },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        data: { message: "logged out successfully." }
      }, status: :ok
    else
      render json: {
        data: { message: "Couldn't find an active session." }
      }, status: :unauthorized
    end
  end
end
