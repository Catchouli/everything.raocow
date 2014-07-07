class ChannelsController < ApplicationController

  before_action :authenticate_admin, except: [:index, :show]
  before_action :channel_exists, except: [:index, :new]

  def index
    @channels = Channel.paginate(page: params[:page])
  end

  def new
    @channel = Channel.new
  end

  def show
    @channel = Channel.find_by_id(params[:id])
    @videos = @channel.videos.paginate(page: params[:page],
                                       per_page: 20).order('published_at DESC')
  end

  def edit
    @channel = Channel.find_by_id(params[:id])

  end

    private

      def channel_exists
        if @channel == nil
          flash[:error] = "No such channel #{params[:id]}"
          redirect_to channels_url
        end
      end

end
