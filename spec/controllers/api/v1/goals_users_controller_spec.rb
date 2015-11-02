describe Api::V1::GoalsUsersController do
  render_views

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @subscription = create :subscription, goal: goal, user: @user
  end

  context 'With a valid authenticity_token' do

    describe 'the \'user\' role' do

      before :each do
        request.headers['X-User-Email'] = @user.email
        request.headers['X-User-Token'] = @user.authentication_token
      end

      it 'creates a subscription' do
        attr = {goal_id: @subscription.goal_id, user_id: @user.id}
        post :create, attr, format: :json

        expect(response.status).to eq 201
        expect(response).to render_template 'api/v1/goals/_goal.json.jbuilder'
        expect(response).to match_response_schema 'schema'
        expect(GoalsUsers.find_by goal_id: attr[:goal_id], user_id: attr[:user_id]).not_to be nil
      end

      it 'updates own subscription' do
        attr = {id: @subscription.id, completed: true}
        put :update, attr, format: :json
        @subscription.reload

        expect(response.status).to eq 200
        expect(response).to render_template 'api/v1/goals/_goal.json.jbuilder'
        expect(response).to match_response_schema 'schema'
        expect(@subscription.completed).to eq attr[:completed]
      end

      it 'deletes own subscription' do
        delete :destroy, id: @subscription.id

        expect(response.status).to eq 204
        expect(GoalsUsers.find_by id: @subscription.id).to be nil
      end

    end
  end
end
