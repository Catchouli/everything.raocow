class Category < ActiveRecord::Base
  searchkick

  validates :name, presence: true, uniqueness: true

  has_many :categorisations, dependent: :destroy
  has_many :videos, through: :categorisations

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
end
