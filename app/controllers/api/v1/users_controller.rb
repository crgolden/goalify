module Api
  module V1
    class UsersController < ApiController
      include UsersHelper
      load_resource

      def index
      end

      def show
      end

      def create
        if user_signed_in? && current_user.admin?
          @user.save ? create_success : create_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def update
        if user_signed_in? && (current_user.admin? || (current_user == @user))
          check_password
          if needs_password?
            @user.update(user_params) ? update_success : update_errors
          else
            @user.update_without_password(user_params) ? update_success : update_errors
          end
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      def destroy
        if user_signed_in? && (current_user.admin? || (current_user == @user))
          @user.soft_delete ? destroy_success : destroy_errors
        else
          render json: {message: 'Unauthorized'}, status: 401
        end
      end

      private

      def user_params
        accessible = [:name, :email]
        accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
        params.require(:user).permit(accessible)
      end

      def query_params
        params.permit(:name)
      end
    end
  end
end
