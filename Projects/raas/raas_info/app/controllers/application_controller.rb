class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def blue_button_class(resource)
    request.env['PATH_INFO'].start_with?("/#{resource}") ? 'active' : ''
  end
  helper_method :blue_button_class
end
