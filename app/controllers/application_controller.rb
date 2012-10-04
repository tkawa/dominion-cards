class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  private
  def set_locale
    available = %w(ja en)
    I18n.locale = request.preferred_language_from(available)
  end
end
