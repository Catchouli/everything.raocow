class ChannelsController < ApplicationController

  before_action :authenticate_admin, except: [:index, :show]
  before_action :channel_exists, except: [:index, :new, :create]

  def index
    @channels = Channel.paginate(page: params[:page])
  end

  def show
    @channel = Channel.find_by_id(params[:id])
    @videos = @channel.videos.paginate(page: params[:page],
                                       per_page: 20).order('published_at DESC')
  end

  def new
    @channel = Channel.new
  end

  def edit
    @channel = Channel.find_by_id(params[:id])
  end

  def create
    p = params.require(:channel).permit(:username, :alias)

    @channel = Channel.new(p)

    if @channel.save
      flash[:success] = "Successfully created channel #{@channel.name }"
      redirect_to channel_url(@channel)
    else
      render 'new'
    end
  end

  def update
    p = params.require(:channel).permit(:username, :alias, :user_id)

    if @channel.update_attributes(p)    
      flash[:success] = "Successfully updated channel"
      redirect_to channel_path(@channel)
    else
      render 'edit'
    end
  end

  def destroy

    @channel.destroy

    flash[:success] = "Successfully destroyed channel #{@channel.name}"

    redirect_to channels_url

  end

  private

    def channel_exists
      @channel = Channel.find_by_id(params[:id])

      if @channel == nil
        flash[:error] = "No such channel #{params[:id]}"
        redirect_to channels_url
      end
    end
end
