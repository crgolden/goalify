module GoalsHelper
    def create_success
    flash[:success] = 'Goal successfully created'
    respond_to do |format|
      format.html { redirect_to @goal }
      format.json { render :show, status: :created, goal: @goal }
    end
  end

  def create_errors
    flash[:error] = 'There was a problem creating the goal'
    respond_to do |format|
      format.html { render :new }
      format.json { render json: @comment.errors, status: :unprocessable_entity }
    end
  end

  def update_success
    flash[:success] = 'Goal was successfully updated.'
    respond_to do |format|
      format.html { redirect_to @goal }
      format.json { render :show, status: :ok, goal: @goal }
    end
  end

  def update_errors
    flash[:error] = 'There was a problem updating the goal.'
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @goal.errors, status: :unprocessable_entity }
    end
  end

  def destroy_success
    flash[:success] = 'Goal was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to goals_path }
      format.json { head :no_content }
    end
  end
end
