require 'youtube_it'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_start_time

  include UserHelper

  def default_url_options(options = nil)
    @port = Rails::Server.new.options[:Port]

    @port = 80 if Rails.env.production?

    { :host => "everything.raocow.com",
      :port => @port }
  end

  protected
    def set_start_time
      @start_time = Time.now
    end

end
