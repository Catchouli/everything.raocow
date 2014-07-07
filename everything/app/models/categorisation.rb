class Categorisation < ActiveRecord::Base
  belongs_to :video
  belongs_to :category
end
