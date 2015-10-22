describe UsersController do

  before :each do
    @user = create :user
  end

  context 'For a visitor' do

    it 'shows a User' do
      get :show, id: @user.id

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(assigns :user).to eq @user
    end
    it 'shows all the Users' do
      get :index

      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'shows edit page for own User' do
        get :edit, id: @user.id

        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(assigns :user).to eq @user
      end

      it 'updates own User with valid email (with password)' do
        attr = {email: Faker::Internet.email, password: @user.password, password_confirmation: @user.password}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:notice]).to eq I18n.t 'users.update.unconfirmed_success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @user
        expect(@user.unconfirmed_email).to eq attr[:email]
      end
      it 'updates own User with valid name (without password)' do
        attr = {name: Faker::Name.name}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:success]).to eq I18n.t 'users.update.confirmed_success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @user
        expect(@user.name).to eq attr[:name]
      end

      it 'doesn\'t update own user with invalid email' do
        attr = {email: 'bademail'}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:error]).to eq I18n.t 'users.update.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(@user.unconfirmed_email).not_to eq attr[:email]
      end
      it 'doesn\'t update own user without name' do
        attr = {name: ''}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:error]).to eq I18n.t 'users.update.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(@user.name).not_to eq attr[:name]
      end

      it 'deletes own user' do
        delete :destroy, id: @user.id
        @user.reload

        expect(flash[:success]).to eq I18n.t 'users.update.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @user
        expect(@user.status).to eq 'inactive'
      end

    end

    describe 'in the \'admin\' role' do

      before :each do
        sign_in create :admin
      end

      it 'creates another User with valid data (unconfirmed)' do
        attr = {name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password}
        post :create, user: attr

        expect(flash[:notice]).to eq I18n.t 'users.create.unconfirmed_success'
        expect(response.status).to eq 302
        expect(User.find_by name: attr[:name], email: attr[:email]).not_to be nil
      end

      it 'creates another User with valid data (confirmed)' do
        attr = {name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password,
                confirmed_at: Time.now}
        post :create, user: attr


        expect(flash[:success]).to eq I18n.t 'users.create.confirmed_success'
        expect(response.status).to eq 302
        expect(User.find_by name: attr[:name], email: attr[:email]).not_to be nil
      end

      it 'doesn\'t create another User with invalid email' do
        attr = {name: Faker::Name.name, email: 'bad_email', password: Faker::Internet.password}
        post :create, user: attr

        expect(flash[:error]).to eq I18n.t 'users.create.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :new
        expect(User.find_by name: attr[:name], email: attr[:email]).to be nil
      end
      it 'doesn\'t create another User without a name' do
        attr = {name: '', email: Faker::Internet.email, password: Faker::Internet.password}
        post :create, user: attr

        expect(flash[:error]).to eq I18n.t 'users.create.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :new
        expect(User.find_by name: attr[:name], email: attr[:email]).to be nil
      end
      it 'doesn\'t create another User without a password' do
        attr = {name: Faker::Name.name, email: Faker::Internet.email, password: ''}
        post :create, user: attr

        expect(flash[:error]).to eq I18n.t 'users.create.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :new
        expect(User.find_by name: attr[:name], email: attr[:email]).to be nil
      end

      it 'shows edit page for another User' do
        get :edit, id: @user.id

        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(assigns :user).to eq @user
      end

      it 'updates another User with valid email' do
        attr = {email: Faker::Internet.email}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:notice]).to eq I18n.t 'users.update.unconfirmed_success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @user
        expect(@user.unconfirmed_email).to eq attr[:email]
      end
      it 'updates another User with valid name' do
        attr = {name: Faker::Name.name}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:success]).to eq I18n.t 'users.update.confirmed_success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @user
        expect(@user.name).to eq attr[:name]
      end

      it 'doesn\'t update another User with invalid email' do
        attr = {email: 'bademail'}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:error]).to eq I18n.t 'users.update.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(@user.unconfirmed_email).not_to eq attr[:email]
      end
      it 'doesn\'t update another User without name' do
        attr = {name: ''}
        put :update, id: @user.id, user: attr
        @user.reload

        expect(flash[:error]).to eq I18n.t 'users.update.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(@user.name).not_to eq attr[:name]
      end

      it 'deletes another User' do
        delete :destroy, id: @user.id
        @user.reload

        expect(flash[:success]).to eq I18n.t 'users.update.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @user
        expect(@user.status).to eq 'inactive'
      end
    end

  end
end