class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :categorisations, dependent: :destroy
  has_many :videos, through: :categorisations

  enum cat_type: [ :category, :series ]
end
