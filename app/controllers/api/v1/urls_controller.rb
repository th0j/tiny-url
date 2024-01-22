class Api::V1::UrlsController < Api::V1::ApiController
  before_action :authenticate_user!, except: :show

  def index
    @pagy, @urls = pagy current_user.urls
    render json: UrlSerializer.new(@urls, serializer_params)
  end

  def create
    create_url_service = CreateUrlService.new(url_params, current_user)

    if create_url_service.call
      return render json: UrlSerializer.new(create_url_service.url), status: :ok
    elsif create_url_service.url.present?
      GenerateUrlJob.perform_async(create_url_service.url.id)
      return render json: { data: { status: :ok, message: 'Your URL is submited and processing.' } }, status: :ok
    end

    render json: { errors: { status: :bad_request, message: 'Something went wrong' } }, status: :bad_request
  end

  def show
    url = Url.popular(params[:id])
    if url.present?
      render json: UrlSerializer.new(url)
    else
      render json: { errors: { message: 'Not found' } }, status: :not_found
    end
  end

  def destroy
    current_user.urls.find_by(id: params[:id])&.destroy
    head :no_content
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end
