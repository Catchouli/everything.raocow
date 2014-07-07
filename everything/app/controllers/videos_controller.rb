class VideosController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  def index
    category_id = params[:category_id]

    if category_id
      @category = Category.find_by_id(category_id)
      @videos = @category.videos
    end
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

      categories = (params["video"]["category_ids"] - [""]).map{ |v| v.to_i }

      Categorisation.where(video_id: video.id).each do |c|
        c.destroy
      end

      categories.each do |c|
        Categorisation.new(video_id: video.id, category_id: c).save
      end

      redirect_to video_path(video)

    end
  end
end
