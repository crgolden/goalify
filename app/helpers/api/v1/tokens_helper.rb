module Api
  module V1
    module TokensHelper
      def destroy_success
        render json: {message: 'Token successfully deleted'}, status: 200
      end

      def destroy_errors
        render json: {error: 'Token could not be deleted.'}, status: 422
      end
    end
  end
end
