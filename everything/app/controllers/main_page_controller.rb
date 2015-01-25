class MainPageController < ApplicationController

  def index

    @hide_navbar = true

    # Get recent videos - we get this locally instead of using the youtube
    # api in case it gets videos we don't have cached yet
    recentVids = Video.order(:published_at => :desc).first 8

    # Request info from youtube api
    videoIdList = recentVids.map { |v| v.video_id }
    videoData = YoutubeAuth.client.videos(videoIdList)

    @recent = recentVids.map { |v| {internal_id: v.id,
                                    video_id: v.video_id,
                                    title: videoData[v.video_id].title,
                                    views: videoData[v.video_id].view_count,
                                    duration: duration_to_str(videoData[v.video_id].duration) } }

    # Get popular videos (highest view count) straight from the youtube api
    @popular = YoutubeAuth.client
                .videos_by(:author => 'raocow', :order_by => 'viewCount')
                .videos.first(8)
                .map { |v| {
                            video_id: v.unique_id,
                            title: v.title,
                            views: v.view_count,
                            duration: duration_to_str(v.duration) } }
   
    @popular.each do |v|
      vid = Video.find_by_video_id(v[:video_id])

      if vid != nil
        v[:internal_id] = vid.id
      else
        v[:internal_id] = 0
      end
    end

  end

  def hi

  end

end
