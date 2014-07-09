require 'youtube_it'

module YoutubeClient

  def youtube_client
    YouTubeIt::Client.new
  end

end
