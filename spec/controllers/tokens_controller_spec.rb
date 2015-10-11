describe TokensController do

  before :each do
    @user = create :user
    @token = create :token, user: @user
  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
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
        expect(Token.find_by id: @token.id).to be nil
      end

    end
  end
end
