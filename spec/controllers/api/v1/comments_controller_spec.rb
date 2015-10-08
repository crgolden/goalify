describe Api::V1::CommentsController do
  include Api::V1::ApiHelper

  before :each do
    @user = create :user
    goal = create :goal, user: @user
    @comment = create :comment, user: @user, goal: goal
  end

  # GET /comments/:id
  it 'returns a single comment' do
    api_get "comments/#{@comment.id}"
    response.status.should == 200

    comment = JSON.parse(response.body)
    expect(comment['id']).to eq @comment.id
    expect(comment['goal_id']).to eq @comment.goal_id
    expect(comment['body']).to eq @comment.body
    expect(comment['user_id']).to eq @comment.user_id
  end
end