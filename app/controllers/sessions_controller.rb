class SessionsController < ApplicationController
  def new
  end

  def create
    session[:role] = params[:role]
    redirect_to root_path, notice: "Logged in as #{params[:role].capitalize}"
  end

  def destroy
    session[:role] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
