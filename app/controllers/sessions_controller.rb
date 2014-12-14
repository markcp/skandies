class SessionsController < ApplicationController
  def new
    @year = Year.current
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:alert] = 'Invalid email/password combination'
      @year = Year.current
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
