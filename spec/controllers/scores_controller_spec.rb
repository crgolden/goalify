describe ScoresController do

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @score = create :score, goal: goal, user: @user
  end

  context 'For a visitor' do

    it 'shows a Score' do
      get :show, id: @score.id

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(assigns :score).to eq @score
    end
    it 'shows all the Scores for a Goal' do
      get :index, goal_id: @score.goal_id

      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'doesn\'t create a Score with valid data' do
        attr = {value: 50}
        post :create, score: attr, goal_id: @score.goal_id

        expect(flash[:error]).to eq 'Access denied!'
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end

      it 'doesn\'t show the edit page for own Score' do
        get :edit, id: @score.id

        expect(flash[:error]).to eq 'Access denied!'
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end

      it 'doesn\'t update own Score with valid value' do
        attr = {value: 100}
        put :update, id: @score.id, score: attr
        @score.reload

        expect(flash[:error]).to eq 'Access denied!'
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end

      it 'doesn\'t delete own Score' do
        delete :destroy, id: @score.id

        expect(flash[:error]).to eq 'Access denied!'
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
        expect(Score.find_by id: @score.id).not_to be nil
      end

    end
  end
end
