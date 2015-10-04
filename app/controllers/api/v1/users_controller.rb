module Api
  module V1
    class UsersController < ApplicationController
      include UsersHelper
      load_resource
      acts_as_token_authentication_handler_for User, except: [:show, :index], fallback: :exception

      def index
      end

      def show
      end

      def create
        if user_signed_in? && current_user.admin?
          @user.save ? create_success : create_errors
        else
          render json: {message: 'Not authorized'}, status: 401
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
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      def destroy
        if user_signed_in? && (current_user.admin? || (current_user == @user))
          destroy_success if @user.soft_delete
        else
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      private

      def user_params
        accessible = [:name, :email]
        accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
        params.require(:user).permit(accessible)
      end
    end
  end
end
