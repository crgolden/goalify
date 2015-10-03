describe UsersController do

  before :each do
    @user = create :user
  end

  context 'When the user is not signed in' do

    it 'shows all the Users' do
      post :index
      expect(response.status).to eq 200
      expect(response).to render_template 'index'
    end

    it 'should show a User' do
      post :show, id: @user.id
      expect(response.status).to eq 200
      expect(response).to render_template 'show'
      expect(assigns :user).to eq @user
    end

  end

  context 'When the user is signed in' do

    before :each do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end

    it 'edits a User' do
      post :edit, id: @user.id
      expect(response.status).to eq 200
      expect(response).to render_template 'edit'
    end

    it 'updates a User (password required)' do
      post :update, id: @user.id, user: {name: 'Updated Name', password: @user.password,
                                         password_confirmation: @user.password}
      expect(response.status).to eq 302
      expect(response).to redirect_to @user
    end

    it 'doesn\'t create a user' do
      post :create, user: {name: 'Name'}
      expect(response.status).to eq 200
      expect(response).to render_template 'new'
    end
  end

  context 'When the admin is signed in' do

    before :each do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
      sign_in create :admin
    end

    it 'creates a User' do
      expect(User).to receive(:new).and_return @user
      post :create, user: {name: 'Name'}
      expect(response.status).to eq 302
      expect(response).to redirect_to @user
    end

    it 'updates a User with valid data (no password required)' do
      post :update, id: @user.id, user: {name: 'Updated Name'}
      expect(response.status).to eq 302
      expect(response).to redirect_to @user
    end

    it 'doesn\'t update a User without valid data (no password required)' do
      post :update, id: @user.id, user: {name: ''}
      expect(response.status).to eq 200
      expect(response).to render_template 'edit'
    end

    it 'deletes a User' do
      post :destroy, id: @user.id
      expect(response.status).to eq 302
      expect(response).to redirect_to users_path
    end
  end
end
