describe CommentsController do

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @comment = create :comment, goal: goal, user: @user
  end

  context 'When the user is not signed in' do

    it 'shows all the Comments for a Goal' do
      post :index, goal_id: @comment.goal_id
      expect(response.status).to eq 200
      expect(response).to render_template 'index'
    end

    it 'shows a Comment' do
      post :show, id: @comment.id
      expect(response.status).to eq 200
      expect(response).to render_template 'show'
      expect(assigns :comment).to eq @comment
    end

    it 'doesn\'t create a Comment' do
      post :create, comment: {body: 'Body'}, goal_id: @comment.goal_id
      expect(response.status).to eq 302
      expect(response).to redirect_to new_user_session_path
    end

    it 'doesn\'t edit a Comment' do
      post :edit, id: @comment.id
      expect(response.status).to eq 302
      expect(response).to redirect_to new_user_session_path
    end

  end

  context 'When the user is signed in' do

    before :each do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end

    it 'creates a Comment with valid data' do
      post :create, comment: {body: 'Body'}, goal_id: @comment.goal_id
      expect(response.status).to eq 302
      expect(response).to redirect_to @comment.goal
    end

    it 'doesn\'t create a Comment without valid data' do
      post :create, comment: {body: ''}, goal_id: @comment.goal_id
      expect(response.status).to eq 302
      expect(response).to redirect_to @comment.goal
    end

    it 'edits a Comment' do
      post :edit, id: @comment.id
      expect(response.status).to eq 200
      expect(response).to render_template 'edit'
    end

    it 'updates a Comment with valid data' do
      post :update, id: @comment.id, comment: {body: 'Updated Body'}
      expect(response.status).to eq 302
      expect(response).to redirect_to @comment.goal
    end

    it 'doesn\'t update a Comment without valid data' do
      post :update, id: @comment.id, comment: {body: ''}
      expect(response.status).to eq 200
      expect(response).to render_template 'edit'
    end

    it 'deletes a Comment' do
      post :destroy, id: @comment.id
      expect(response.status).to eq 302
      expect(response).to redirect_to goal_comments_path(@comment.goal)
    end

  end
end
