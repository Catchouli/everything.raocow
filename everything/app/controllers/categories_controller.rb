class CategoriesController < ApplicationController
  include CategoryHelper

  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]
  before_filter :authenticate_admin, only: [:destroy]
  before_filter :category_exists,    except: [:index, :new, :create, :random, :search]
#  before_filter :check_correct_type, only: [:show, :edit]
  before_filter :set_cat_type

  helper_method :category_path
  helper_method :edit_category_path
  helper_method :new_category_path
  helper_method :categories_path
  helper_method :category_videos_path
  helper_method :videos_random_category_path

  helper_method :category_url
  helper_method :edit_category_url
  helper_method :new_category_url
  helper_method :categories_url
  helper_method :category_videos_url
  helper_method :videos_random_category_url

  def index
    @categories = Category.where(cat_type: Category.cat_types[cat_type]).
                           paginate(page: params[:page], per_page: params[:per_page]).order('last_published DESC')
  end

  def show
    @videos = @category.videos.paginate(page: params[:page],
                                       per_page: params[:per_page]).order('published_at ASC')
  end

  def new
    @category = Category.new

    # Save cat_type
    session[:cat_type] = cat_type
  end

  def create
    # Restore cat_type
    cat_type = session[:cat_type]

    @category = Category.new(category_params.merge({cat_type: cat_type}))

    if @category.save
      flash[:success] = "#{cat_type} #{@category.name} added"
      redirect_to category_path(@category)
    else
      render 'new'
    end
  end

  def edit
    @videos = Video.all
  end

  def update

    videos = (params["category"]["video_ids"] - [""]).map{ |c| c.to_i }

    Categorisation.where(category_id: @category.id).delete_all

    Categorisation.create(videos.map { |v| { category_id: @category.id, video_id: v } })

    # Update params
    p = params.permit(:name)

    if @category.update_attributes(p)
      flash[:success] = "Successfully updated #{cat_type} #{@category.name}"
      redirect_to category_path(@category)
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy if @category

    flash[:success] = "Successfully destroyed #{cat_type} #{@category.name}"
    redirect_to action: :index
  end

  def random
    if Category.count == 0
      redirect_to root_url
    else
      redirect_to category_url(Category.random(cat_type))
    end
  end

  def search

    if params.has_key?(:query)

      @results = Category.search(params[:query], where: { cat_type: cat_type }, page: params[:page], per_page: params[:per_page])

      render 'shared/search_results.html.erb', locals: { resource: capitalize(cat_type), options: { info: [:name], thumbnails: true } }

    else

      render 'shared/search_form.html.erb', locals: { resource: capitalize(cat_type) }

    end

  end

  private

    def category_exists
      @category = Category.find_by_id(params[:id])

      if @category == nil
        flash[:error] = "No such #{cat_type} #{params[:id]}"
        redirect_to categories_url
      end
    end

    #warning currently broken TODO:
    def check_correct_type
      category = Category.find_by_id(params[:id])

      current_uri = request.env['PATH_INFO']

      correct_uri = current_uri.sub(%r{^/(.*)/}, "/#{category.cat_type.pluralize(0)}/")

      if (current_uri != correct_uri)
        redirect_to correct_uri
      end
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def set_cat_type
      @cat_type = cat_type
    end

    def cat_type
      %r{/(\w*)\b}.match(request.original_fullpath)[1].singularize
    end

    # route function overrides
    def category_videos_path(id)
      if cat_type == "category"
        return super(id)
      end

      return send("#{cat_type}_videos_path", id)
    end

    def categories_path
      if cat_type == "category"
        return super
      end

      if cat_type.pluralize(0) == cat_type
        return send("#{cat_type}_index_path")
      else
        return send("#{cat_type.pluralize(0)}_path")
      end
    end

    def new_category_path
      if cat_type == "category"
        return super
      end

      return send("#new_{cat_type}_path")
    end

    def edit_category_path(id)
      if cat_type == "category"
        return super(id)
      end

      return send("edit_#{cat_type}_path", id)
    end

    def category_path(id)
      if cat_type == "category"
        return super(id)
      end

      return send("#{cat_type}_path", id)
    end

    def videos_random_category_path(id)
      if cat_type == "category"
        return super(id)
      end

      return send("videos_random_#{cat_type}_path", id)
    end

    def category_videos_url(id)
      if cat_type == "category"
        return super(id)
      end

      return send("#{cat_type}_videos_url", id)
    end

    def categories_url
      if cat_type == "category"
        return super
      end

      if cat_type.pluralize(0) == cat_type
        return send("#{cat_type}_index_url")
      else
        return send("#{cat_type.pluralize(0)}_url")
      end
    end

    def new_category_url
      if cat_type == "category"
        return super
      end

      return send("#new_{cat_type}_url")
    end

    def edit_category_url(id)
      if cat_type == "category"
        return super(id)
      end

      return send("edit_#{cat_type}_url", id)
    end

    def category_url(id)
      if cat_type == "category"
        return super(id)
      end

      return send("#{cat_type}_url", id)
    end

    def videos_random_category_url(id)
      if cat_type == "category"
        return super(id)
      end

      return send("videos_random_#{cat_type}_url", id)
    end
end
