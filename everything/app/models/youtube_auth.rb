require 'youtube_it'

class YoutubeAuth < ActiveRecord::Base

  validates_inclusion_of :singleton_guard, in: [0]

  def self.client

    auth = YoutubeAuth.last

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

    auth.update_columns(access_token: client.access_token,
                        refresh_token: res.refresh_token)
  end

end
