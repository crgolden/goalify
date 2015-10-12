describe Api::V1::CommentsController do
  render_views

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @comment = create :comment, goal: goal, user: @user
  end

  context 'Without a valid authenticity_token' do

    it 'shows a comment' do
      get :show, id: @comment.id, format: :json
      comment = json_response[:comment]

      expect(response.status).to eq 200
      expect(response).to render_template :show
      expect(response).to match_response_schema('comment')
      expect(comment[:id]).to eq @comment.id
      expect(comment[:body]).to eq @comment.body
      expect(comment[:user][:id]).to eq @comment.user.id
      expect(comment[:goal][:id]).to eq @comment.goal.id
      expect(assigns :comment).to eq @comment
    end
    it 'shows all the comments' do
      get :index, goal_id: @comment.goal_id, format: :json

      expect(response.status).to eq 200
      expect(response).to render_template :index
      expect(response).to match_response_schema('comments')
      expect(json_response).to have_key(:meta)
      expect(json_response[:meta]).to have_key(:pagination)
      expect(json_response[:meta][:pagination]).to have_key(:per_page)
      expect(json_response[:meta][:pagination]).to have_key(:total_pages)
      expect(json_response[:meta][:pagination]).to have_key(:total_objects)
    end

  end

  context 'With a valid authenticity_token' do

    describe 'the \'user\' role' do

      before :each do
        request.headers['X-User-Email'] = @user.email
        request.headers['X-User-Token'] = @user.authentication_token
      end

      it 'creates a comment with valid data' do
        attr = {body: 'Body'}
        post :create, comment: attr, goal_id: @comment.goal_id, format: :json
        comment = json_response[:comment]

        expect(response.status).to eq 201
        expect(response).to render_template :show
        expect(response).to match_response_schema('comment')
        expect(comment[:body]).to eq attr[:body]
        expect(Comment.find_by body: attr[:body]).not_to be nil
      end

      it 'updates own comment with valid data' do
        attr = {body: 'Updated Body'}
        put :update, id: @comment.id, comment: attr, format: :json
        comment = json_response[:comment]
        @comment.reload

        expect(response.status).to eq 200
        expect(response).to render_template :show
        expect(response).to match_response_schema('comment')
        expect(comment[:body]).to eq attr[:body]
        expect(@comment.body).to eq attr[:body]
      end

      it 'deletes own comment' do
        delete :destroy, id: @comment.id

        expect(response.status).to eq 204
        expect(Comment.find_by id: @comment.id).to be nil
      end

    end
  end
end
