module CommentsHelper
  def create_success
    flash[:success] = 'Comment successfully created'
    respond_to do |format|
      format.html { redirect_to @comment.goal }
      format.json { render :show, status: :created, comment: @comment }
    end
  end

  def create_errors
    flash[:error] = 'There was a problem creating the comment'
    respond_to do |format|
      format.html { redirect_to @comment.goal }
      format.json { render json: @comment.errors, status: :unprocessable_entity }
    end
  end

  def update_success
    flash[:success] = 'Comment was successfully updated.'
    respond_to do |format|
      format.html { redirect_to @comment.goal }
      format.json { render :show, status: :ok, comment: @comment }
    end
  end

  def update_errors
    flash[:error] = 'There was a problem updating the Comment.'
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @comment.errors, status: :unprocessable_entity }
    end
  end

  def destroy_success
    flash[:success] = 'Comment was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to goal_comments_path(@comment.goal) }
      format.json { head :no_content }
    end
  end
end
