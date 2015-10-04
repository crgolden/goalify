module Api
  module V1
    class TokensController < ApplicationController
      include TokensHelper
      load_resource :user
      load_resource :token, through: :user, only: [:index]
      load_resource :token, only: [:show, :destroy]
      acts_as_token_authentication_handler_for User, fallback: :exception

      def index
        if user_signed_in? && (current_user.admin? || current_user == @user)
          render :index
        else
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      def show
        if user_signed_in? && (current_user.admin? || current_user == @token.user)
          render :show
        else
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      def destroy
        if user_signed_in? && (current_user.admin? || current_user == @token.user)
          destroy_success if @token.destroy
        else
          render json: {message: 'Not authorized'}, status: 401
        end
      end

      private

      def token_params
      end
    end
  end
end