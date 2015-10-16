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

end
