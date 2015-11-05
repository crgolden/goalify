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

      it 'Deletes a Token' do
        delete :destroy, id: @token

        expect(flash[:notice]).to eq I18n.t 'tokens.destroy.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to tokens_user_path(@token.user)
        expect(Token.find_by id: @token.id).to be nil
      end

    end
  end
end
