require 'open-uri'

class Channel < ActiveRecord::Base
  has_many :videos, dependent: :destroy

  validates :username, presence: true, uniqueness: true

  after_create :init

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
    self.user_id = get_user_id
    self.save

    ch = Yt::Channel.new(url: "youtube.com/#{self.username}")

    ch.videos.each do |v|
      self.videos.new(title: v.title,
                      video_id: v.id,
                      published_at: v.published_at)
    end

    self.save
  end

  def update
    last_video = videos.order("published_at").last

    if last_video
      last_updated = last_video.published_at

      time_range = last_updated .. (Date.today+1)

      query = { user: self.username, fields: { published: time_range } }

      ch = Yt::Channel.new(url: "youtube.com/#{self.username}")

      last_published = self.videos.order('published_at DESC').first.published_at.utc.iso8601(0)

      ch.videos.where(published_after: last_published).each do |v|

        logger.info "Adding video: #{v.title}"

        self.videos.new(title: v.title,
                          video_id: v.id,
                          published_at: v.published_at)

        self.save

      end
    else
      logger.warn "update called on uninitialised channel"
    end

    true
  end

  def thumbnail
    "https://i.ytimg.com/i/#{self.user_id}/1.jpg"
  end
end
