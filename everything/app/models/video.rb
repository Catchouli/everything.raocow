class Video < ActiveRecord::Base
  searchkick

  include ActionView::Helpers::DateHelper

  belongs_to :channel

  has_many :categorisations, dependent: :destroy
  has_many :categories, through: :categorisations

  validates :title, presence: true
  validates :video_id, presence: true, uniqueness: true
  validates :published_at, presence: true

  def player_url
    "http://www.youtube.com/watch?v=#{video_id}&feature=youtube_gdata_player"
  end

  def thumbnail
    "http://i1.ytimg.com/vi/#{self.video_id}/default.jpg"    
  end

  def name
    "#{self.title}"
  end

  def description
    YoutubeAuth.client.video_by(self.video_id).description
  end

  def time
    "#{time_ago_in_words(self.published_at)} ago"
  end

  def channel_name
    self.channel.name
  end

  def self.random
    Video.offset(rand(Video.count)).limit(1)[0]
  end
end
