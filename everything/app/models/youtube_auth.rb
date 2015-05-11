require 'youtube_it'
require 'yt'

class YoutubeAuth < ActiveRecord::Base

  validates_inclusion_of :singleton_guard, in: [0]

  def self.client

    if Time.now - YoutubeAuth.first.updated_at > 30.minutes

      YoutubeAuth.refresh

    end

    auth = YoutubeAuth.first

    YouTubeIt::OAuth2Client.new(client_access_token: auth.access_token,
                                client_refresh_token: auth.refresh_token,
                                client_id: auth.client_id,
                                client_secret: auth.client_secret,
                                dev_key: auth.dev_key)

  end

  def self.refresh
  
    auth = YoutubeAuth.last

    client = YouTubeIt::OAuth2Client.new(client_access_token: auth.access_token,
                                         client_refresh_token: auth.refresh_token,
                                         client_id: auth.client_id,
                                         client_secret: auth.client_secret,
                                         dev_key: auth.dev_key)

    res = client.refresh_access_token!

    auth.update_attributes(access_token: client.access_token.token,
                           refresh_token: res.refresh_token)

    
  end

end
