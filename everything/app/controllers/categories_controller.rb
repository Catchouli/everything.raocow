class CategoriesController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create]

  def index
    @categories = Category.paginate(page: params[:page])
  end

  def show
    @category = Category.find_by_id(params[:id])
    @videos = @category.videos.paginate(page: params[:page],
                                       per_page: 20).order('published_at DESC')
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category #{@category.name} added"
      redirect_to categories_path
    else
      render 'new'
    end
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end
