describe Api::V1::CommentsController do
  include ApiHelper

  before :each do
    user = create :user
    goal = create :goal, user: user
    @header = {'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token}
    @comment = create :comment, user: user, goal: goal
  end

  context 'Without a valid authenticity_token' do

    # GET /comments/:id
    it 'returns a comment' do
      api_get "comments/#{@comment.id}"
      comment = json['comment']
      expect(response.status).to eq 200
      expect(comment['id']).to eq @comment.id
      expect(comment['body']).to eq @comment.body
      expect(comment['user']).to eq api_v1_user_url(@comment.user)
      expect(comment['goal']).to eq api_v1_goal_url(@comment.goal)
    end

  end

  context 'With a valid authenticity_token' do

  end
end
