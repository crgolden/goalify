describe Api::V1::GoalsController do
  render_views

  before :each do
    @user = create :user
    @goal= create :goal, user: @user
  end

  context 'Without a valid authenticity_token' do

    it 'shows a goal' do
      get :show, id: @goal.id, format: :json
      goal = json_response[:goal]

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(response).to match_response_schema 'schema'
      expect(goal[:id]).to eq @goal.id
      expect(goal[:user_id]).to eq @goal.user_id
      expect(goal[:title]).to eq @goal.title
      expect(goal[:text]).to eq @goal.text
      expect(assigns :goal).to eq @goal
    end
    it 'shows all the goals' do
      get :index, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :index
      expect(response).to match_response_schema 'schema'
      expect(json_response).to have_key :meta
      expect(json_response[:meta]).to have_key :pagination
      expect(json_response[:meta][:pagination]).to have_key :per_page
      expect(json_response[:meta][:pagination]).to have_key :total_pages
      expect(json_response[:meta][:pagination]).to have_key :total_objects
    end

    it 'doesn\'t create new goal' do
      attr = {title: 'New Title', text: 'New Text'}
      post :create, goal: attr, format: :json
      goal = json_response

      expect(response.status).to eq 401
      expect(goal[:error]).to eq I18n.t 'devise.failure.unauthenticated'
      expect(Goal.find_by title: attr[:title], text: attr[:text]).to be nil
    end

    it 'doesn\'t update own goal' do
      attr = {title: 'New Title'}
      put :update, id: @goal.id, goal: attr, format: :json
      goal = json_response
      @goal.reload

      expect(response.status).to eq 401
      expect(goal[:error]).to eq I18n.t 'devise.failure.unauthenticated'
      expect(@goal.title).not_to eq attr[:title]
    end

    it 'shows all the Comments for a Goal' do
      get :comments, id: @goal.id, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :comments
      expect(response).to match_response_schema 'schema'
      expect(json_response).to have_key :meta
      expect(json_response[:meta]).to have_key :pagination
      expect(json_response[:meta][:pagination]).to have_key :per_page
      expect(json_response[:meta][:pagination]).to have_key :total_pages
      expect(json_response[:meta][:pagination]).to have_key :total_objects
    end

    it 'shows all the Scores for a Goal' do
      get :scores, id: @goal.id, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :scores
      expect(response).to match_response_schema 'schema'
      expect(json_response).to have_key :meta
      expect(json_response[:meta]).to have_key :pagination
      expect(json_response[:meta][:pagination]).to have_key :per_page
      expect(json_response[:meta][:pagination]).to have_key :total_pages
      expect(json_response[:meta][:pagination]).to have_key :total_objects
    end

    it 'shows all the Search results for a goal' do
      get :search, q: 'Title', format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :search
      expect(response).to match_response_schema 'schema'
      expect(json_response).to have_key :meta
      expect(json_response[:meta]).to have_key :pagination
      expect(json_response[:meta][:pagination]).to have_key :per_page
      expect(json_response[:meta][:pagination]).to have_key :total_pages
      expect(json_response[:meta][:pagination]).to have_key :total_objects
    end

    it 'shows all the Subscribers for a Goal' do
      get :subscribers, id: @goal.id, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :subscribers
      expect(response).to match_response_schema 'schema'
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

      it 'creates a goal with valid data' do
        attr = {title: 'New Title', text: 'New Text'}
        post :create, attr, format: :json
        goal = json_response[:goal]

        expect(response.status).to eq 201
        expect(response).to render_template :show
        expect(response).to match_response_schema 'schema'
        expect(goal[:title]).to eq attr[:title]
        expect(goal[:text]).to eq attr[:text]
        expect(Goal.find_by title: attr[:title], text: attr[:text]).not_to be nil
      end

      it 'doesn\'t create a goal with blank title' do
        attr = {title: '', text: 'New Text'}
        post :create, goal: attr, format: :json
        goal = json_response

        expect(response.status).to eq 422
        expect(goal[:title].first).to eq 'can\'t be blank'
        expect(Goal.find_by title: attr[:title], text: attr[:text]).to be nil
      end

      it 'updates own goal with valid data' do
        attr = {id: @goal.id, title: 'Updated Title', text: 'Updated Text'}
        put :update, attr, format: :json
        goal = json_response[:goal]
        @goal.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema 'schema'
        expect(goal[:title]).to eq attr[:title]
        expect(@goal.title).to eq attr[:title]
      end

      it 'doesn\'t update own goal with blank title' do
        attr = {id: @goal.id, title: ''}
        put :update, attr, format: :json
        goal = json_response
        @goal.reload

        expect(response.status).to eq 422
        expect(goal[:title].first).to eq 'can\'t be blank'
        expect(@goal.title).not_to eq attr[:title]
      end

      it 'doesn\'t delete own goal' do
        request.env['HTTP_REFERER'] = root_path
        delete :destroy, id: @goal.id, format: :json

        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq I18n.t 'cancan.ability.error'
        expect(Goal.find_by id: @goal.id).not_to be nil
      end

    end

    describe 'the \'admin\' role' do

      before :each do
        @admin = create :admin
        request.headers['X-User-Email'] = @admin.email
        request.headers['X-User-Token'] = @admin.authentication_token
      end

      it 'deletes a goal' do
        delete :destroy, id: @goal.id, format: :json

        expect(response.status).to eq 204
        expect(Goal.find_by id: @goal.id).to be nil
      end

    end
  end
end
