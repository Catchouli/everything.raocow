require 'youtube_it'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_start_time

  include UserHelper

  def default_url_options(options = nil)
    @port = 3000

    @port = 80 if Rails.env.production?

    { :host => "raocow.com",
      :port => @port }
  end

  def duration_to_str(seconds)

    format_str = '%H:%M:%S'

    if seconds < 3600
      format_str = '%M:%S'
    end

    Time.at(seconds).getutc.strftime(format_str)

  end

  protected
    def set_start_time
      @start_time = Time.now
    end

end
