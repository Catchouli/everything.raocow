require 'youtube_it'

class YoutubeClients

  @@default = YouTubeIt::Client.new

  def self.default
    @@default
  end

end
