describe Api::V1::TokensController do
  render_views

  before :each do
    @user = create :user
    @token = create :token, user: @user
  end

  context 'Without a valid authenticity_token' do

    it 'doesn\'t show own token' do
      get :show, id: @token.id, format: :json
      token = json_response

      expect(response.status).to eq 401
      expect(token[:error]).to eq I18n.t 'devise.failure.unauthenticated'
    end
    it 'doesn\'t show all tokens for User' do
      get :index, user_id: @token.user_id, format: :json
      token = json_response

      expect(response.status).to eq 401
      expect(token[:error]).to eq I18n.t 'devise.failure.unauthenticated'
    end

    it 'doesn\'t delete own token' do
      delete :destroy, id: @token.id, format: :json
      token = json_response

      expect(response.status).to eq 401
      expect(token[:error]).to eq I18n.t 'devise.failure.unauthenticated'
      expect(Token.find_by id: @token.id).not_to be nil
    end

  end

  context 'With a valid authenticity_token' do

    before :each do
      request.headers['X-User-Email'] = @user.email
      request.headers['X-User-Token'] = @user.authentication_token
    end

    it 'shows own token' do
      get :show, id: @token.id, format: :json
      token = json_response[:token]

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(response).to match_response_schema 'token'
      expect(token[:id]).to eq @token.id
      expect(assigns :token).to eq @token
    end
    it 'shows all tokens for User' do
      get :index, user_id: @token.user_id, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :index
      expect(response).to match_response_schema 'tokens'
    end

    it 'deletes own token' do
      delete :destroy, id: @token.id

      expect(response.status).to eq 204
      expect(Token.find_by id: @token.id).to be nil
    end

  end
end
