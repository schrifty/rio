class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # TODO restore CSRF - just turned it off so we could keep moving ahead with prototype features
  #protect_from_forgery with: :null_session

  before_filter :update_sanitized_params, if: :devise_controller?
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:display_name, :email, :password)}
  end
end
