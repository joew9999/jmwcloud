class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception
  before_action :set_current_controller

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    if current_user.nil?
      redirect_to new_user_session_path
    else
      redirect_to root_path
    end
  end

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def set_current_controller
    @current_controller = params[:controller]
  end
end
