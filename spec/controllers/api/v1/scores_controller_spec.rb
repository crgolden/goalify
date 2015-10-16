describe Api::V1::ScoresController do
  render_views

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @score = create :score, goal: goal, user: @user
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
      expect(score[:user_id]).to eq @score.user_id
      expect(score[:goal_id]).to eq @score.goal_id
      expect(assigns :score).to eq @score
    end
    it 'shows all the scores' do
      get :index, goal_id: @score.goal_id, format: :json

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

  context 'With a valid authenticity_token' do

    describe 'the \'user\' role' do

      before :each do
        request.headers['X-User-Email'] = @user.email
        request.headers['X-User-Token'] = @user.authentication_token
      end

      it 'creates a score with valid value' do
        attr = {value: 50}
        post :create, score: attr, goal_id: @score.goal_id, format: :json
        score = json_response[:score]

        expect(response.status).to eq 201
        expect(response).to render_template :show
        expect(response).to match_response_schema 'score'
        expect(score[:value]).to eq attr[:value]
        expect(Score.find_by value: attr[:value]).not_to be nil
      end

      it 'updates own score with valid value' do
        attr = {value: 100}
        put :update, id: @score.id, score: attr, format: :json
        score = json_response[:score]
        @score.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema 'score'
        expect(score[:value]).to eq attr[:value]
        expect(@score.value).to eq attr[:value]
      end

      it 'doesn\'t update own score with blank value' do
        attr = {value: ''}
        put :update, id: @score.id, score: attr, format: :json
        score = json_response
        @score.reload

        expect(response.status).to eq 422
        expect(score[:value].first).to eq 'can\'t be blank'
        expect(@score.value).not_to eq attr[:value]
      end

      it 'deletes own score' do
        delete :destroy, id: @score.id

        expect(response.status).to eq 204
        expect(Score.find_by id: @score.id).to be nil
      end

    end
  end
end
