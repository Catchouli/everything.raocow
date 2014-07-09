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

  def random
    if Video.count == 0
      redirect_to root_url
    else
      redirect_to video_url(Video.random.id)
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
