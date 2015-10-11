describe TokensController do

  describe 'When the user is signed in' do

    before :each do
      user = create :user
      sign_in user
      @token = create :token, user: user
    end

    it 'Shows a Token' do
      get :show, id: @token.id

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(assigns :token).to eq @token
    end

    it 'Shows all the Tokens for a User' do
      get :index, user_id: @token.user_id

      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

    it 'Deletes a Token' do
      delete :destroy, id: @token

      expect(flash[:success]).to eq 'Token was successfully deleted.'
      expect(response.status).to eq 302
      expect(response).to redirect_to @token.user
    end
  end
end
