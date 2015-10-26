module CommentsHelper

  protected

  def filter
    if params[:goal]
      @goal = Goal.includes(:comments).find params[:goal]
      comments = @goal.comments
    elsif params[:user]
      @user = User.includes(:comments).find params[:user]
      comments = @user.comments
    else
      comments = Comment.all
    end
    @comments = comments.accessible_by(current_ability).includes(:goal, :user).page(params[:page]).per params[:per_page]
  end

  def create_success
    flash[:success] = I18n.t('comments.create.success')
    redirect_to comments_path
  end

  def create_errors
    flash[:error] = I18n.t('comments.create.errors')
    redirect_to @comment.goal
  end

  def update_success
    flash[:success] = I18n.t('comments.update.success')
    redirect_to @comment
  end

  def update_errors
    flash[:error] = I18n.t('comments.update.errors')
    render :edit
  end

  def destroy_success
    flash[:success] = I18n.t('comments.destroy.success')
    redirect_to comments_path
  end

end