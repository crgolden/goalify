module Api
  module V1
    class GoalsController < ApplicationController
      include GoalsHelper
      load_resource
      acts_as_token_authentication_handler_for User, except: [:show, :index], fallback: :exception

      def index
      end

      def show
      end

      def create
        if user_signed_in?
          @goal.user = current_user
          @goal.save ? create_success : create_errors
        else
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      def update
        if user_signed_in? && (current_user.admin? || (current_user == @goal.user))
          @goal.update(goal_params) ? update_success : update_errors
        else
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      def destroy
        if user_signed_in? && (current_user.admin? || (current_user == @goal.user))
          destroy_success if @goal.destroy
        else
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      private

      def goal_params
        params.require(:goal).permit(:title, :text)
      end
    end
  end
end
