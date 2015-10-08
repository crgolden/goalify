describe Api::V1::UsersController do
  include ApiHelper

  before :each do
    @user = create :user
    @header = {'X-User-Email' => @user.email, 'X-User-Token' => @user.authentication_token}
  end

  context 'Without a valid authenticity_token' do

    it 'returns a user' do
      api_get "users/#{@user.id}"
      expect(response.status).to eq 200
      expect(response).to match_response_schema('user')
    end

    it 'returns all the users' do
      api_get 'users'
      expect(response.status).to eq 200
      expect(response).to render_template 'index'
    end

  end

  context 'With a valid authenticity_token' do

    # it 'updates a user' do
    #   api_put "admin/users/#{@user.id}", {'X-User-Email' => @user.email, 'X-User-Token' => @user.authentication_token}
    #   expect(response.status).to eq 200
    #   expect(response).to match_response_schema('user')
    # end

    context 'as an admin' do

      # it 'creates a user' do
      #   api_post 'admin/users', {'X-User-Email' => @user.email, 'X-User-Token' => @user.authentication_token, user: {name: 'Name', email: Faker::Internet.email, password: 'password'}}
      #   expect(User.last.name).to eq('Name')
      # end

    end

  end
end
