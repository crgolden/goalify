module Api
  module V1
    class TokensController < ApiController
      include TokensHelper
      load_resource :user
      load_resource :token, through: :user, only: [:index]
      load_resource :token, only: [:show, :destroy]

      def index
        if user_signed_in? && (current_user.admin? || current_user == @user)
          render :index
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def show
        if user_signed_in? && (current_user.admin? || current_user == @token.user)
          render :show
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def destroy
        if user_signed_in? && (current_user.admin? || current_user == @token.user)
          @token.destroy ? destroy_success : destroy_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      private

      def token_params
      end
    end
  end
end