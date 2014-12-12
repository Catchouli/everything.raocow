class Categorisation < ActiveRecord::Base
  belongs_to :video
  belongs_to :category

  before_validation :update_categories

  def update_categories
    category.update_published_at
  end
end
