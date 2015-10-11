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

      it 'creates a Comment with valid data' do
        attr = {body: 'New Body'}
        post :create, comment: attr, goal_id: @comment.goal_id

        expect(flash[:success]).to eq 'Comment successfully created.'
        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(Comment.find_by body: attr[:body]).not_to be nil
      end

      it 'doesn\'t create a Comment without a Body' do
        attr = {body: ''}
        post :create, comment: attr, goal_id: @comment.goal.id

        expect(flash[:error]).to eq 'There was a problem creating the comment.'
        expect(response.status).to eq 302
        expect(response).to redirect_to @comment.goal
        expect(Comment.find_by body: attr[:body]).to be nil
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

        expect(flash[:success]).to eq 'Comment was successfully updated.'
        expect(response.status).to eq 302
        expect(response).to redirect_to @comment.goal
        expect(@comment.body).to eq attr[:body]
      end

      it 'doesn\'t update own Comment without a Body' do
        attr = {body: ''}
        put :update, id: @comment.id, comment: attr
        @comment.reload

        expect(flash[:error]).to eq 'There was a problem updating the comment.'
        expect(response.status).to eq 200
        expect(response).to render_template :edit
        expect(@comment.body).not_to eq attr[:body]
      end

      it 'deletes own Comment' do
        delete :destroy, id: @comment.id

        expect(flash[:success]).to eq 'Comment was successfully deleted.'
        expect(response.status).to eq 302
        expect(response).to redirect_to @comment.goal
        expect(Comment.find_by id: @comment.id).to be nil
      end

    end
  end
end
