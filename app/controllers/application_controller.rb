class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout :false
  protect_from_forgery with: :exception

  def verify_authentication
  	if AuthenticationHelper.authenticated?(request) == false
  		return head :unauthorized
  	end
  end
end
