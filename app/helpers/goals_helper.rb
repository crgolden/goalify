module GoalsHelper
  def create_success
    flash[:success] = 'Goal successfully created'
    redirect_to @goal
  end

  def create_errors
    flash[:error] = 'There was a problem creating the goal'
    render :new
  end

  def update_success
    flash[:success] = 'Goal was successfully updated.'
    redirect_to @goal
  end

  def update_errors
    flash[:error] = 'There was a problem updating the goal.'
    render :edit
  end

  def destroy_success
    flash[:success] = 'Goal was successfully deleted.'
    redirect_to goals_path
  end
end
