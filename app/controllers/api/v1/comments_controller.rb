module Api
  module V1
    class CommentsController < ApiController
      include CommentsHelper
      load_resource :goal
      load_resource :comment, through: :goal, shallow: true

      def index
      end

      def show
      end

      def create
        if user_signed_in?
          @comment = @goal.comments.create(comment_params)
          @comment.user = current_user
          @comment.save ? create_success : create_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def update
        if user_signed_in? && (current_user.admin? || (current_user == @comment.user))
          @comment.update(comment_params) ? update_success : update_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def destroy
        if user_signed_in? && (current_user.admin? || (current_user == @comment.user))
          @comment.destroy ? destroy_success : destroy_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end