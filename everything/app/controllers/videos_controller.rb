class VideosController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  def index
    @videos = Video.paginate(page: params[:page],
                              per_page: 20).order('published_at DESC')
  end

  def show
    @video = Video.find_by_id(params[:id])

    if @video == nil
      flash[:error] = "Invalid video id #{params[:id]}"
      redirect_to videos_path 
    end
  end

  def edit
    @video = Video.find_by_id(params[:id])

    if @video == nil
      flash[:error] = "Invalid video id #{params[:id]}"
      redirect_to videos_path 
    else
      @categories = Category.all
    end
  end

  def update

    video = Video.find_by_id(params[:id])

    if video == nil

      flash[:error] = "Invalid video id #{params[:id]}"
      redirect_to channels_path 

    else

      categories_all = params["category_ids_all"].split(',').map{|c| c.to_i}

      categories_selected = (params["video"]["category_ids"] - [""]).map{ |v| v.to_i }

      Categorisation.where(category_id: categories_all, video_id: video).destroy_all

      if Categorisation.create(categories_selected.map { |c| { category_id: c, video_id: video.id } })

        flash[:success] = "Succesfully updated video"

        redirect_to video_url(video)

      else

        flash[:error] = "Failed to update video"

        redirect_to edit_video_url(video)

      end

    end
  end

  def random
    if Video.count == 0
      redirect_to root_url
    else
      redirect_to video_url(Video.random.id)
    end
  end

  def search

    if params.has_key?(:query)

      @results = Video.search params[:query], page: params[:page], per_page: 30

      render 'shared/search_results.html.erb', locals: { resource: "Video" }

    else

      render 'shared/search_form.html.erb', locals: { resource: "Video" }

    end

  end
end
