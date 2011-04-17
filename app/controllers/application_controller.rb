class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    account = YAML.load_file("#{Rails.root}/config/auth.yml")
    if session[:user_id].blank?
      redirect_to "/"
      return
    end
  end

end
