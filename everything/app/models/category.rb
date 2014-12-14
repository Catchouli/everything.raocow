class Category < ActiveRecord::Base
  searchkick

  validates :name, presence: true, uniqueness: true

  has_many :categorisations, dependent: :destroy
  has_many :videos, -> { order(published_at: :asc) }, through: :categorisations

  enum cat_type: [ :category, :series ]

  def thumbnail
    if self.videos.count > 0
      return self.videos.first.thumbnail
    else
      # Return default (not found) video thumbnail
      return Video.new.thumbnail
    end
  end

  def self.random(cat_type)
    res = Category.where(cat_type: Category.cat_types[cat_type]).all

    return res[rand(res.count)]
  end

  def update_published_at
    if videos.count == 0
      self.last_published = Time.at(0)
    else
      self.last_published = Video
        .joins('INNER JOIN categorisations ON videos.id = categorisations.video_id')
        .where('categorisations.category_id' => self.id)
        .order(:published_at => :desc)
          .first.published_at
    end

    self.save
  end
end
