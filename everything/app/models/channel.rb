require 'youtube_it'
require 'open-uri'

class Channel < ActiveRecord::Base
  has_many :videos, dependent: :destroy

  validates :username, presence: true, uniqueness: true

  def name

    if self.alias && self.alias != ""
      return self.alias
    end

    self.username

  end

  def get_user_id

    user_url = "https://gdata.youtube.com/feeds/api/users/#{self.username}"

    match = open(user_url).read.match(/api\/users\/([A-Za-z0-9\-]*)/)

    if match.length > 1
      return match[1]
    end

    ""
  end

  def init
    client = YouTubeIt::Client.new

    self.user_id = get_user_id
    self.save

    client.get_all_videos(user: self.username).each do |v|
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

      query = { user: self.username, fields: { published: time_range } }

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
