class VideosController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]

  def index
    @videos = Video.paginate(page: params[:page],
                              per_page: 20).order('published_at DESC')
  end

  def feed
    @videos = Video.paginate(page: params[:page],
                              per_page: 20).order('published_at DESC')

    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def uncategorised
    Video.includes(:categories).where(:categorisations => { :video_id => nil } )
  end

  def show
    @video = Video.find_by_id(params[:id])
    
    @related_videos = []

    @video.categories.each do |c|
      @related_videos += c.videos.all.to_a
    end

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
      @categories = Category.all.reverse
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

      if params.has_key?(:category_search) && params.has_key?(:id)

        category = Category.find_by_id(params[:id])

        if category.videos.count == 0

          flash[:error] = 'No videos in category'

          redirect_to request.referer

        else

          cat_videos = category.videos

          random_video_path = "/" + category.cat_type.pluralize(0) + "/" + category.id.to_s + "/videos/random"

          flash[:random_video] = "<a href=\"#{random_video_path}\">Another random video from #{category.cat_type} #{category.name}</a>".html_safe

          redirect_to video_url(cat_videos[rand(cat_videos.count)])

        end

      elsif params.has_key?(:channel_search) && params.has_key?(:id)

        channel = Channel.find_by_id(params[:id])

        cat_videos = channel.videos

        random_video_path = videos_random_channel_path(channel)

        flash[:random_video] = "<a href=\"#{random_video_path}\">Another random video from channel #{channel.name}</a>".html_safe

        redirect_to video_url(cat_videos[rand(cat_videos.count)])

      else

        flash[:random_video] = "<a href=\"#{random_videos_path}\">Another random video</a>".html_safe

        redirect_to video_url(Video.random.id)

      end
    end
  end

  def search

    if params.has_key?(:query)

      cat_filter = false

      categories = []

      Category.cat_types.each do |c_t|

        if params.has_key?("filter_" + c_t[0]) && params["filter_" + c_t[0]] == "true"

          cat_filter = true

          categories -= Category.where(cat_type: c_t[1]).select(:id).map{ |c| c.id }

          if params.has_key?(c_t[0] + "_ids")

            categories += params[c_t[0] + "_ids"].map{ |c| c.to_i }

          end

        end

      end

      if !cat_filter

        categories = Category.all.select(:id).map{ |c| c.id }

      end


      if cat_filter
      
        cat_videos = Categorisation.where(category_id: categories).select(:video_id).map{ |v| v.video_id }

        @results = Video.search params[:query],
                                where: { id: cat_videos },
                                page: params[:page],
                                per_page: 20

      else

        @results = Video.search params[:query],
                                page: params[:page],
                                per_page: 20
      end

      render 'shared/search_results.html.erb', locals: { resource: "Video" }

    else

      render 'shared/search_form.html.erb', locals: { resource: "Video" }

    end

  end
end
