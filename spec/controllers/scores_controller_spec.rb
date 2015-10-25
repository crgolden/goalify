describe ScoresController do

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    subscription = create :subscription, goal: goal, user: @user
    @score = create :score, subscription: subscription
  end

  context 'For a visitor' do

    it 'shows a Score' do
      get :show, id: @score.id

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(assigns :score).to eq @score
    end
    it 'shows all the Scores for a Subscription' do
      get :index, subscription: @score.subscription

      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

  end

end
