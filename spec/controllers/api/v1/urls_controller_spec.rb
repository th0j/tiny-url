describe Api::V1::UrlsController, type: :controller do
  login_user

  let(:url) { create_list(:url, 5, user: subject.current_user) }
  let(:url_another_user) { create(:url) }

  describe "GET #index" do
    context 'with existing urls' do
      before do
        url
        get :index
      end

      it 'should returns all urls was created by current user' do
        expect(JSON.parse(response.body)['data'].count).to eq(5)
      end
    end

    context 'with empty urls' do
      before do
        get :index
      end

      it { expect(JSON.parse(response.body)['data'].count).to eq(0) }
    end
  end

  describe "POST #create" do
    before do
      post :create, params:
    end

    context 'with empty params' do
      let(:params) { {} }
      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'with original_url is not http or https' do
      let(:params) { { url: { original_url: 'htt://www.google.com' } } }
      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'with valid params' do
      let(:params) { { url: { original_url: 'https://www.google.com' } } }

      it { expect(JSON.parse(response.body)['data']['attributes']['slug']).to_not be_empty }
    end
  end

  describe "GET #show" do
    before do
      url
      get :show, params:
    end

    context 'with url do not exist' do
      let(:params) { { id: 'google' } }

      it { expect(JSON.parse(response.body)['errors']).to_not be_empty }
    end

    context 'with url existed' do
      let(:params) { { id: url.first.slug } }

      it { expect(JSON.parse(response.body)['data']['id']).to_not be_empty }
    end
  end

  describe "DELETE #delete" do
    before do
      url
      url_another_user
      delete :destroy, params:
    end

    context 'with id does not exist' do
      let(:params) { { id: SecureRandom.uuid } }

      it 'should return 200 and do not delete anything' do
        expect(response).to have_http_status(:no_content)
        expect(Url.count).to eq(6)
      end
    end

    context 'with id exist' do
      let(:params) { { id: url.first.id } }
      it 'should return 200 and delete one url' do
        expect(response).to have_http_status(:no_content)
        expect(Url.count).to eq(5)
      end
    end

    context 'with url of another user' do
      let(:params) { { id: url_another_user.id } }
      it 'should return 200 and do not delete anything' do
        expect(response).to have_http_status(:no_content)
        expect(Url.count).to eq(6)
      end
    end
  end
end
