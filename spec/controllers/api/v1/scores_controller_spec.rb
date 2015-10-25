describe Api::V1::ScoresController do
  render_views

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    subscription = create :subscription, goal: goal, user: @user
    @score = create :score, subscription: subscription
  end

  context 'Without a valid authenticity_token' do

    it 'shows a score' do
      get :show, id: @score.id, format: :json
      score = json_response[:score]

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(response).to match_response_schema 'score'
      expect(score[:id]).to eq @score.id
      expect(score[:value]).to eq @score.value
      expect(score[:subscription_id]).to eq @score.subscription_id
      expect(assigns :score).to eq @score
    end
    it 'shows all the scores' do
      get :index, subscription: @score.subscription, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :index
      expect(response).to match_response_schema 'scores'
      expect(json_response).to have_key :meta
      expect(json_response[:meta]).to have_key :pagination
      expect(json_response[:meta][:pagination]).to have_key :per_page
      expect(json_response[:meta][:pagination]).to have_key :total_pages
      expect(json_response[:meta][:pagination]).to have_key :total_objects
    end

  end

end
