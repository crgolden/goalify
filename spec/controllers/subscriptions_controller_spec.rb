describe SubscriptionsController do

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @subscription = create :subscription, goal: goal, user: @user
  end

  context 'For a visitor' do

    it 'shows a Subscription' do
      get :show, id: @subscription.id

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(assigns :subscription).to eq @subscription
    end
    it 'shows all the Subscriptions for a Goal' do
      get :index, goal_id: @subscription.goal_id

      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'creates a Subscription' do
        attr = {completed: false}
        post :create, subscription: attr, goal_id: @subscription.goal_id

        expect(flash[:success]).to eq 'Subscription successfully created.'
        expect(response.status).to eq 302
        expect(Subscription.find_by completed: attr[:completed]).not_to be nil
      end

      it 'shows the edit page for own Subscription' do
        get :edit, id: @subscription.id

        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(assigns :subscription).to eq @subscription
      end

      it 'updates own Subscription' do
        attr = {completed: true}
        put :update, id: @subscription.id, subscription: attr
        @subscription.reload

        expect(flash[:success]).to eq 'Subscription was successfully updated.'
        expect(response.status).to eq 302
        expect(response).to redirect_to @subscription
        expect(@subscription.completed).to eq attr[:completed]
      end

      it 'deletes own Subscription' do
        delete :destroy, id: @subscription.id

        expect(flash[:success]).to eq 'Subscription was successfully deleted.'
        expect(response.status).to eq 302
        expect(response).to redirect_to @subscription.goal
        expect(Subscription.find_by id: @subscription.id).to be nil
      end

    end
  end
end
