describe GoalsController do

  before :each do
    @user = create :user
    @goal = create :goal, user: @user
  end

  context 'When the user is not signed in' do

    it 'shows all the Goals' do
      post :index
      expect(response.status).to eq 200
      expect(response).to render_template 'index'
    end

    it 'shows a Goal' do
      post :show, id: @goal.id
      expect(response.status).to eq 200
      expect(response).to render_template 'show'
      expect(assigns :goal).to eq @goal
    end

    it 'doesn\'t create a goal' do
      post :create, goal: {title: 'Title'}
      expect(response.status).to eq 302
      expect(response).to redirect_to new_user_session_path
    end

  end

  context 'When the user is signed in' do

    before :each do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end

    it 'creates a Goal with valid data' do
      expect(Goal).to receive(:new).and_return @goal
      post :create, goal: {title: 'Title'}
      expect(response.status).to eq 302
      expect(response).to redirect_to @goal
    end

    it 'doesn\'t create a Goal without valid data' do
      post :create, goal: {title: ''}
      expect(response.status).to eq 200
      expect(response).to render_template 'new'
    end

    it 'edits a Goal' do
      post :edit, id: @goal.id
      expect(response.status).to eq 200
      expect(response).to render_template 'edit'
    end

    it 'updates a Goal with valid data' do
      post :update, id: @goal.id, goal: {title: 'Updated Title'}
      expect(response.status).to eq 302
      expect(response).to redirect_to @goal
    end

    it 'doesn\'t update a Goal without valid data' do
      post :update, id: @goal.id, goal: {title: ''}
      expect(response.status).to eq 200
      expect(response).to render_template 'edit'
    end

  end

  context 'When the admin is signed in' do

    before :each do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
      sign_in create :admin
    end

    it 'deletes a Goal' do
      post :destroy, id: @goal.id
      expect(response.status).to eq 302
      expect(response).to redirect_to goals_path
    end
  end
end
