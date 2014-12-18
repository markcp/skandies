class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include YearsHelper

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:alert] = "Please log in."
      redirect_to login_url
    end
  end
end
