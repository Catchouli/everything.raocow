require 'youtube_it'

class Channel < ActiveRecord::Base
  has_many :videos

  validates :name, presence: true, uniqueness: true

  def init
    client = YouTubeIt::Client.new

    client.get_all_videos(user: self.name).each do |v|
      self.videos.new(title: v.title,
                      video_id: v.unique_id,
                      published_at: v.published_at)
    end

    self.save
  end

  def update
    client = YouTubeIt::Client.new

    last_video = videos.order("published_at").last

    if last_video
      last_updated = last_video.published_at

      time_range = last_updated .. (Date.today+1)

      query = { user: self.name, fields: { published: time_range } }

        client.videos_by(query).videos.each do |v|
          logger.info "Adding video: #{v.title}"

          self.videos.new(title: v.title,
                          video_id: v.unique_id,
                          published_at: v.published_at)
        end

      self.save
    else
      logger.warn "update called on uninitialised channel"
    end

    true
  end
end
