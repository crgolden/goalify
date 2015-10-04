module Api
  module V1
    module UsersHelper
      def create_success
        render :show, status: :created, location: @user
      end

      def create_errors
        render json: @user.errors, status: :unprocessable_entity
      end

      def update_success
        render :show, status: :ok, location: @user
      end

      def update_errors
        sign_in(@user == current_user ? @user : current_user, bypass: true)
        render json: @user.errors, status: :unprocessable_entity
      end

      def destroy_success
        render json: {message: 'User successfully deleted'}, status: 200
      end

      def destroy_errors
        render json: {error: 'User could not be deleted.'}, status: 422
      end

      protected

      def check_password
        false unless user_params[:password].blank?
        user_params.delete :password
        user_params.delete :password_confirmation
      end

      def needs_password?
        user_params[:password].present? || user_params[:password_confirmation].present?
      end
    end
  end
end
