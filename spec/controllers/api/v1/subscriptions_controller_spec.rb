describe Api::V1::SubscriptionsController do
  render_views

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @subscription = create :subscription, goal: goal, user: @user
  end

  context 'Without a valid authenticity_token' do

    it 'shows a Subscription' do
      get :show, id: @subscription.id, format: :json
      subscription = json_response[:subscription]

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(response).to match_response_schema 'subscription'
      expect(subscription[:id]).to eq @subscription.id
      expect(subscription[:completed]).to eq @subscription.completed
      expect(subscription[:user_id]).to eq @subscription.user_id
      expect(subscription[:goal_id]).to eq @subscription.goal_id
      expect(assigns :subscription).to eq @subscription
    end
    it 'shows all the Subscriptions' do
      get :index, goal_id: @subscription.goal_id, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :index
      expect(response).to match_response_schema 'subscriptions'
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

      it 'creates a subscription with valid completed' do
        attr = {completed: false}
        post :create, subscription: attr, goal_id: @subscription.goal_id, format: :json
        subscription = json_response[:subscription]

        expect(response.status).to eq 201
        expect(response).to render_template :show
        expect(response).to match_response_schema 'subscription'
        expect(subscription[:completed]).to eq attr[:completed]
        expect(Subscription.find_by completed: attr[:completed]).not_to be nil
      end

      it 'updates own subscription with valid completed' do
        attr = {completed: true}
        put :update, id: @subscription.id, subscription: attr, format: :json
        subscription = json_response[:subscription]
        @subscription.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema 'subscription'
        expect(subscription[:completed]).to eq attr[:completed]
        expect(@subscription.completed).to eq attr[:completed]
      end

      it 'deletes own subscription' do
        delete :destroy, id: @subscription.id

        expect(response.status).to eq 204
        expect(Subscription.find_by id: @subscription.id).to be nil
      end

    end
  end
end
