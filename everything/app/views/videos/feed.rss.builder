xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "raocow's videos"
    xml.description ""
    xml.link videos_url

    for video in @videos
      xml.item do
        xml.title video.title
        xml.description video.player_url
        xml.pubDate video.published_at.to_s(:rfc822)
        xml.link video_url(video)
        xml.guid video_url(video)
      end
    end
  end
end

