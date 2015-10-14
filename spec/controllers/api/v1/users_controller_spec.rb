describe Api::V1::UsersController do
  render_views

  before :each do
    @user = create :user
  end

  context 'Without a valid authenticity_token' do

    it 'shows a user' do
      get :show, id: @user.id, format: :json
      user = json_response[:user]

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(response).to match_response_schema 'user'
      expect(user[:id]).to eq @user.id
      expect(user[:email]).to eq @user.email
      expect(user[:name]).to eq @user.name
      expect(assigns :user).to eq @user
    end
    it 'shows all the users' do
      get :index, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :index
      expect(response).to match_response_schema 'users'
      expect(json_response).to have_key :meta
      expect(json_response[:meta]).to have_key :pagination
      expect(json_response[:meta][:pagination]).to have_key :per_page
      expect(json_response[:meta][:pagination]).to have_key :total_pages
      expect(json_response[:meta][:pagination]).to have_key :total_objects
    end

    it 'doesn\'t update own user' do
      attr = {email: Faker::Internet.email}
      put :update, id: @user.id, user: attr, format: :json
      user = json_response
      @user.reload

      expect(response.status).to eq 401
      expect(user[:error]).to eq I18n.t 'devise.failure.unauthenticated'
      expect(@user.unconfirmed_email).not_to eq attr[:email]
    end

    it 'doesn\'t delete own user' do
      delete :destroy, id: @user.id, format: :json
      user = json_response
      @user.reload

      expect(response.status).to eq 401
      expect(user[:error]).to eq I18n.t 'devise.failure.unauthenticated'
      expect(@user.status).not_to eq 'inactive'
    end

  end

  context 'With a valid authenticity_token' do

    describe 'the \'user\' role' do

      before :each do
        request.headers['X-User-Email'] = @user.email
        request.headers['X-User-Token'] = @user.authentication_token
      end

      it 'updates own user with valid name (with password)' do
        attr = {name: Faker::Name.name, password: @user.password,
                password_confirmation: @user.password}
        put :update, id: @user.id, user: attr, format: :json
        user = json_response[:user]
        @user.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema 'user'
        expect(user[:name]).to eq attr[:name]
        expect(@user.name).to eq attr[:name]
      end
      it 'updates own user with valid email (without password)' do
        attr = {email: Faker::Internet.email}
        put :update, id: @user.id, user: attr, format: :json
        user = json_response[:user]
        @user.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema 'user'
        expect(user[:email]).not_to eq attr[:email]
        expect(@user.unconfirmed_email).to eq attr[:email]
      end

      it 'doesn\'t update own user with invalid email' do
        attr = {email: 'bademail'}
        put :update, id: @user.id, user: attr
        user = json_response
        @user.reload

        expect(response.status).to eq 422
        expect(user[:email].first).to eq 'is invalid'
        expect(@user.unconfirmed_email).not_to eq attr[:email]
      end
      it 'doesn\'t update own user with blank name' do
        attr = {name: ''}
        put :update, id: @user.id, user: attr
        user = json_response
        @user.reload

        expect(response.status).to eq 422
        expect(user[:name].first).to eq 'can\'t be blank'
        expect(@user.name).not_to eq attr[:name]
      end

      it 'deletes own user' do
        delete :destroy, id: @user.id, format: :json
        @user.reload

        expect(response.status).to eq 204
        expect(@user.status).to eq 'inactive'
      end

    end

    describe 'the \'admin\' role' do

      before :each do
        @admin = create :admin
        request.headers['X-User-Email'] = @admin.email
        request.headers['X-User-Token'] = @admin.authentication_token
      end

      it 'creates another user with valid data' do
        attr = {name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password}
        post :create, user: attr, format: :json
        user = json_response[:user]

        expect(response.status).to eq 201
        expect(response).to render_template :show
        expect(response).to match_response_schema 'user'
        expect(user[:name]).to eq attr[:name]
        expect(user[:email]).to eq attr[:email]
        expect(User.find_by name: attr[:name], email: attr[:email]).not_to be nil
      end

      it 'doesn\'t create another user with invalid email' do
        attr = {name: Faker::Name.name, email: 'bademail', password: Faker::Internet.password}
        post :create, user: attr
        user = json_response

        expect(response.status).to eq 422
        expect(user[:email].first).to eq 'is invalid'
        expect(User.find_by name: attr[:name], email: attr[:email]).to be nil
      end
      it 'doesn\'t create another user with blank name' do
        attr = {name: '', email: Faker::Internet.email, password: Faker::Internet.password}
        post :create, user: attr, format: :json
        user = json_response

        expect(response.status).to eq 422
        expect(user[:name].first).to eq 'can\'t be blank'
        expect(User.find_by name: attr[:name]).to be nil
      end

      it 'updates another user with valid name (without password)' do
        attr = {name: Faker::Name.name}
        put :update, id: @user.id, user: attr, format: :json
        user = json_response
        @user.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema 'user'
        expect(user[:user][:name]).to eq attr[:name]
        expect(@user.name).to eq attr[:name]
      end
      it 'updates another user with valid email (with password)' do
        attr = {email: Faker::Internet.email}
        put :update, id: @user.id, user: attr, format: :json
        user = json_response
        @user.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema 'user'
        expect(user[:user][:unconfirmed_email]).not_to eq attr[:email]
        expect(@user.unconfirmed_email).to eq attr[:email]
      end

      it 'doesn\'t update another user with invalid email' do
        attr = {email: 'bademail'}
        put :update, id: @user.id, user: attr
        user = json_response
        @user.reload

        expect(response.status).to eq 422
        expect(user[:email].first).to eq 'is invalid'
        expect(@user.unconfirmed_email).not_to eq attr[:email]
      end
      it 'doesn\'t update another user with blank name' do
        attr = {name: ''}
        put :update, id: @user.id, user: attr
        user = json_response
        @user.reload

        expect(response.status).to eq 422
        expect(user[:name].first).to eq 'can\'t be blank'
        expect(@user.name).not_to eq attr[:name]
      end

      it 'deletes another user' do
        delete :destroy, id: @user.id
        @user.reload

        expect(response.status).to eq 204
        expect(@user.status).to eq 'inactive'
      end
    end
  end
end
