describe Api::V1::CommentsController do
  render_views

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @comment = create :comment, goal: goal, user: @user
  end

  context 'With a valid authenticity_token' do

    describe 'the \'user\' role' do

      before :each do
        request.headers['X-User-Email'] = @user.email
        request.headers['X-User-Token'] = @user.authentication_token
      end

      it 'creates a comment with valid body' do
        attr = {body: 'New Body', goal_id: @comment.goal_id, user_id: @user.id}
        post :create, attr, format: :json
        comment = json_response[:comments].last[:comment]

        expect(response.status).to eq 201
        expect(response).to render_template 'api/v1/goals/comments.json.jbuilder'
        expect(response).to match_response_schema 'schema'
        expect(comment[:body]).to eq attr[:body]
        expect(Comment.find_by body: attr[:body]).not_to be nil
      end

      it 'doesn\'t create a comment with blank body' do
        attr = {body: '', goal_id: @comment.goal_id, user_id: @user.id}
        post :create, attr, format: :json
        comment = json_response

        expect(response.status).to eq 422
        expect(comment[:body].last).to eq 'can\'t be blank'
        expect(Comment.find_by body: attr[:body]).to be nil
      end

    end

    describe 'the \'admin\' role' do

      before :each do
        @admin = create :admin
        request.headers['X-User-Email'] = @admin.email
        request.headers['X-User-Token'] = @admin.authentication_token
      end

      it 'deletes a Comment' do
        delete :destroy, id: @comment.id

        expect(response.status).to eq 204
        expect(Comment.find_by id: @comment.id).to be nil
      end

    end

  end
end
