describe CommentsController do

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @comment = create :comment, goal: goal, user: @user
  end

  context 'For a visitor' do

    it 'shows a Comment' do
      get :show, id: @comment.id

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(assigns :comment).to eq @comment
    end
    it 'shows all the Comments for a Goal' do
      get :index, goal_id: @comment.goal_id

      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

  end

  context 'For a signed-in User' do

    describe 'in the \'user\' role' do

      before :each do
        sign_in @user
      end

      it 'creates a Comment with valid body' do
        attr = {body: 'New Body', goal_id: @comment.goal_id, user_id: @user.id}
        post :create, comment: attr

        expect(flash[:success]).to eq I18n.t 'comments.create.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to comments_path(goal_id: @comment.goal_id)
        expect(Comment.find_by user_id: attr[:user_id], goal_id: attr[:goal_id]).not_to be nil
      end

      it 'doesn\'t create a Comment with a blank body' do
        attr = {body: '', goal_id: @comment.goal_id, user_id: @user.id}
        post :create, comment: attr

        expect(flash[:error]).to eq I18n.t 'comments.create.errors'
        expect(response.status).to eq 302
        expect(response).to redirect_to @comment.goal
        expect(Comment.find_by user_id: attr[:user_id], goal_id: attr[:goal_id]).not_to be nil
      end

      it 'shows the edit page for own Comment' do
        get :edit, id: @comment.id

        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(assigns :comment).to eq @comment
      end

      it 'updates own Comment with valid data' do
        attr = {body: 'Updated Body'}
        put :update, id: @comment.id, comment: attr
        @comment.reload

        expect(flash[:success]).to eq I18n.t 'comments.update.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to @comment
        expect(@comment.body).to eq attr[:body]
      end

      it 'doesn\'t update own Comment without a body' do
        attr = {body: ''}
        put :update, id: @comment.id, comment: attr
        @comment.reload

        expect(flash[:error]).to eq I18n.t 'comments.update.errors'
        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(@comment.body).not_to eq attr[:body]
      end

      it 'deletes own Comment' do
        delete :destroy, id: @comment.id

        expect(flash[:success]).to eq I18n.t 'comments.destroy.success'
        expect(response.status).to eq 302
        expect(response).to redirect_to comments_path
        expect(Comment.find_by id: @comment.id).to be nil
      end

    end
  end
end
