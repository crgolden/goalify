module CommentsHelper
  def create_success
    flash[:success] = 'Comment successfully created'
    redirect_to @comment.goal
  end

  def create_errors
    flash[:error] = 'There was a problem creating the comment'
    redirect_to @comment.goal
  end

  def update_success
    flash[:success] = 'Comment was successfully updated.'
    redirect_to @comment.goal
  end

  def update_errors
    flash[:error] = 'There was a problem updating the Comment.'
    render :edit
  end

  def destroy_success
    flash[:success] = 'Comment was successfully deleted.'
    redirect_to goal_comments_path(@comment.goal)
  end
end
