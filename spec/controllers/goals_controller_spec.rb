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

  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'creates a Goal with valid data' do
        attr = {title: 'New Title', text: 'New Text'}
        post :create, goal: attr

        expect(flash[:success]).to eq 'Goal successfully created.'
        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(Goal.find_by title: attr[:title], text: attr[:text]).not_to be nil
      end

      it 'doesn\'t create a Goal without a title' do
        attr = {title: '', text: 'New Text'}
        post :create, goal: attr

        expect(flash[:error]).to eq 'There was a problem creating the goal.'
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

        expect(flash[:success]).to eq 'Goal was successfully updated.'
        expect(response.status).to eq 302
        expect(response).to redirect_to @goal
        expect(@goal.title).to eq attr[:title]
        expect(@goal.text).to eq attr[:text]
      end

      it 'doesn\'t update own Goal without a title' do
        attr = {title: '', text: 'Updated text'}
        put :update, id: @goal.id, goal: attr
        @goal.reload

        expect(flash[:error]).to eq 'There was a problem updating the goal.'
        expect(response.status).to eq 200
        expect(response).to render_template 'edit'
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

        expect(flash[:success]).to eq 'Goal was successfully deleted.'
        expect(response.status).to eq 302
        expect(response).to redirect_to goals_path
      end

    end
  end
end
