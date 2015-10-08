module Api
  module V1
    class GoalsController < ApiController
      include GoalsHelper
      load_resource

      def index
      end

      def show
      end

      def create
        if user_signed_in?
          @goal.user = current_user
          @goal.save ? create_success : create_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def update
        if user_signed_in? && (current_user.admin? || (current_user == @goal.user))
          @goal.update(goal_params) ? update_success : update_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def destroy
        if user_signed_in? && (current_user.admin? || (current_user == @goal.user))
          @goal.destroy ? destroy_success : destroy_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      private

      def goal_params
        params.require(:goal).permit(:title, :text)
      end

      def query_params
        # this assumes that an album belongs to a user and has a :user_id
        # allowing us to filter by this
        params.permit(:user_id, :title)
      end
    end
  end
end
