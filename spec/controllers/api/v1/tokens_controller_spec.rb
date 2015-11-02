describe Api::V1::TokensController do

  before :each do
    @user = create :user
    @token = create :token, user: @user
  end

  context 'With a valid authenticity_token' do

    before :each do
      request.headers['X-User-Email'] = @user.email
      request.headers['X-User-Token'] = @user.authentication_token
    end

    it 'deletes own token' do
      delete :destroy, id: @token.id

      expect(response.status).to eq 204
      expect(Token.find_by id: @token.id).to be nil
    end

  end
end
