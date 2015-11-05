describe GoalsController do

  before :each do
    @user = create :user
    @goal = create :goal, user: @user
  end

  context 'For a visitor' do

    it 'shows a Goal' do
      get :show, id: @goal.id

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(assigns :goal).to eq @goal
    end
    it 'shows all the Goals' do
      get :index

      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

    it 'shows all the Comments for a Goal' do
      get :comments, id: @goal.id

      expect(response.status).to eq 200
      expect(response).to render_template :comments
    end

    it 'shows all the Scores for a Goal' do
      get :scores, id: @goal.id

      expect(response.status).to eq 200
      expect(response).to render_template :scores
    end

    it 'shows all the Search results for a Goal' do
      get :search, q: 'Title'

      expect(response.status).to eq 200
      expect(response).to render_template :search
    end

    it 'shows all the Subscribers for a Goal' do
      get :subscribers, id: @goal.id

      expect(response.status).to eq 200
      expect(response).to render_template :subscribers
    end

  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'creates a Goal with valid data' do
        attr = {title: 'New Title', text: 'New Text'}
        post :create, goal: attr

        expect(flash[:notice]).to eq I18n.t 'goals.create.success'
        expect(response.status).to eq 302
        expect(Goal.find_by title: attr[:title], text: attr[:text]).not_to be nil
      end

      it 'doesn\'t create a Goal without a title' do
        attr = {title: '', text: 'New Text'}
        post :create, goal: attr

        expect(flash[:notice]).to eq I18n.t 'goals.errors', count: '1 error'
        expect(response.status).to eq 200
        expect(response).to render_template :new
        expect(Goal.find_by title: attr[:title], text: attr[:text]).to be nil
      end

      it 'shows the edit page for own Goal' do
        get :edit, id: @goal.id

        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(assigns :goal).to eq @goal
      end

      it 'updates own Goal with valid data' do
        attr = {title: 'Updated Title', text: 'Updated text'}
        put :update, id: @goal.id, goal: attr
        @goal.reload

        expect(flash[:notice]).to eq I18n.t 'goals.update.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @goal
        expect(@goal.title).to eq attr[:title]
        expect(@goal.text).to eq attr[:text]
      end

      it 'doesn\'t update own Goal without a title' do
        attr = {title: '', text: 'Updated text'}
        put :update, id: @goal.id, goal: attr
        @goal.reload

        expect(flash[:notice]).to eq I18n.t 'goals.errors', count: '1 error'
        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(@goal.title).not_to eq attr[:title]
        expect(@goal.text).not_to eq attr[:text]
      end

    end

    describe 'in the \'admin\' role' do

      before :each do
        sign_in create :admin
      end

      it 'deletes a Goal' do
        delete :destroy, id: @goal.id

        expect(flash[:notice]).to eq I18n.t 'goals.destroy.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to goals_path
      end

    end
  end
end
