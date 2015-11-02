describe GoalsUsersController do

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @subscription = create :subscription, goal: goal, user: @user
    request.env['HTTP_REFERER'] = goal_path(goal)
  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'creates a GoalsUsers' do
        attr = {goal_id: @subscription.goal_id, user_id: @user.id}
        post :create, subscription: attr

        expect(flash[:success]).to eq I18n.t 'goals_users.create.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @subscription.goal
        expect(GoalsUsers.find_by goal_id: attr[:goal_id], user_id: attr[:user_id]).not_to be nil
      end

      it 'updates own GoalsUsers' do
        attr = {completed: true}
        put :update, id: @subscription.id, subscription: attr
        @subscription.reload

        expect(flash[:success]).to eq I18n.t 'goals_users.update.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @subscription.goal
        expect(@subscription.completed).to eq attr[:completed]
      end

      it 'deletes own GoalsUsers' do
        delete :destroy, id: @subscription.id

        expect(flash[:success]).to eq I18n.t 'goals_users.destroy.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @subscription.goal
        expect(GoalsUsers.find_by id: @subscription.id).to be nil
      end

    end
  end
end
