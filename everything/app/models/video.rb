class Video < ActiveRecord::Base
  belongs_to :channel

  has_many :categorisations, dependent: :destroy
  has_many :categories, through: :categorisations

  validates :title, presence: true
  validates :video_id, presence: true, uniqueness: true
  validates :published_at, presence: true

  def player_url
    "http://www.youtube.com/watch?v=#{video_id}&feature=youtube_gdata_player"
  end
end
