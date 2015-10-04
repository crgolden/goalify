module Api
  module V1
    module CommentsHelper
      def create_success
        render :show, status: :created, location: @comment
      end

      def create_errors
        render json: @comment.errors, status: :unprocessable_entity
      end

      def update_success
        render :show, status: :ok, location: @comment
      end

      def update_errors
        render json: @comment.errors, status: :unprocessable_entity
      end

      def destroy_success
        render json: {message: 'Comment successfully deleted'}, status: 200
      end

      def destroy_errors
        render json: {error: 'Comment could not be deleted.'}, status: 422
      end
    end
  end
end
