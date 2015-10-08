describe TokensController do

  describe 'When the user is signed in' do

    before :each do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      user = create :user
      sign_in user
      @token = create :token, user: user
    end

    it 'Shows a Token' do
      post :show, id: @token.id, user_id: @token.user_id
      expect(response.status).to eq 200
      expect(response).to render_template 'show'
      expect(assigns :token).to eq @token
    end

    it 'Shows all the Tokens' do
      post :index, user_id: @token.user_id
      expect(response.status).to eq 200
      expect(response).to render_template 'index'
    end

    it 'Deletes a Token' do
      post :destroy, id: @token, user_id: @token.user_id
      expect(response.status).to eq 302
      expect(response).to redirect_to @token.user
    end
  end
end
