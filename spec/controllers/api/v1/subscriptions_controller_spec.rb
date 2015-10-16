describe Api::V1::SubscriptionsController do
  render_views

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @subscription = create :subscription, goal: goal, user: @user
  end

  context 'Without a valid authenticity_token' do

    it 'doesn\'t show a subscription' do
      get :show, id: @subscription.id, format: :json
      subscription = json_response

      expect(response.status).to eq 401
      expect(subscription[:error]).to eq I18n.t 'devise.failure.unauthenticated'
    end
    it 'doesn\'t show all the subscriptions' do
      get :index, goal_id: @subscription.goal_id, format: :json
      subscription = json_response

      expect(response.status).to eq 401
      expect(subscription[:error]).to eq I18n.t 'devise.failure.unauthenticated'
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
