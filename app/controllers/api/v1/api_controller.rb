class Api::V1::ApiController < ApplicationController
  respond_to :json

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  def serializer_params
    { meta: }
  end

  private

  def meta
    {
      total_pages: @pagy.pages,
      items_per_page: @pagy.items
    }
  end

  def parameter_missing(exception)
    render json: { errors: [
      {
        title: 'Parameter Missing',
        detail: exception.message
      }
    ] }, status: :bad_request
  end
end
