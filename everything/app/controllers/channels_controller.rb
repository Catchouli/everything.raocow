class ChannelsController < ApplicationController

  def index
    @channels = Channel.paginate(page: params[:page])
  end

  def show
    client = YouTubeIt::Client.new

    @channel = Channel.find_by_id(params[:id])
    @videos = @channel.videos.paginate(page: params[:page],
                                       per_page: 20).order('published_at DESC')
  end

end
