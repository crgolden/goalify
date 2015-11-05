describe CommentsController do

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @comment = create :comment, goal: goal, user: @user
  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'creates a Comment with valid body' do
        attr = {body: 'New Body', goal_id: @comment.goal_id, user_id: @user.id}
        post :create, comment: attr

        expect(flash[:notice]).to eq I18n.t 'comments.create.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to comments_goal_path(@comment.goal)
        expect(Comment.find_by user_id: attr[:user_id], goal_id: attr[:goal_id]).not_to be nil
      end

      it 'doesn\'t create a Comment with a blank body' do
        attr = {body: '', goal_id: @comment.goal_id, user_id: @user.id}
        post :create, comment: attr

        expect(flash[:error]).to eq I18n.t 'comments.errors', count: '1 error'
        expect(response.status).to eq 200
        expect(response).to render_template 'goals/show'
        expect(Comment.find_by user_id: attr[:user_id], goal_id: attr[:goal_id]).not_to be nil
      end

    end

    describe 'in the \'admin\' role' do

      before :each do
        sign_in create :admin
      end

      it 'deletes a Comment' do
        delete :destroy, id: @comment.id

        expect(flash[:notice]).to eq I18n.t 'comments.destroy.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to comments_goal_path(@comment.goal)
        expect(Comment.find_by id: @comment.id).to be nil
      end

    end

  end
end
