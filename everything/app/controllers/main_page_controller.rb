class MainPageController < ApplicationController

  def index

    @hide_navbar = true

    # Get recent videos - we get this locally instead of using the youtube
    # api in case it gets videos we don't have cached yet
    recentVids = Video.order(:published_at => :desc).first(8)

    # Request info from youtube api
    videoIdList = recentVids.map { |v| v.video_id }
    internalIds = recentVids.map { |v| v.id }
    videoData = Yt::Collections::Videos.new.where(part: 'snippet,statistics,contentDetails', id: videoIdList.join(','))

    @recent = videoData.map.with_index { |v, i| {internal_id: internalIds[i],
                                   video_id: v.id,
                                   title: v.title,
                                   views: v.view_count,
                                   duration: duration_to_str(v.duration) } }

    ch = Yt::Channel.new url: 'youtube.com/raocow'

    # Get popular videos (highest view count) straight from the youtube api
    popularIds = ch.videos.where(order: 'viewcount').first(8).map { |v| v.id }

    @popular = Yt::Collections::Videos.new.where(part: 'snippet,statistics,contentDetails', id: popularIds.join(','))
                .map { |v| {
                            video_id: v.id,
                            title: v.title,
                            views: v.view_count,
                            duration: duration_to_str(v.duration) } }

    # Get local ids
    popularVids = Video.where(video_id: @popular.map { |v| v[:video_id] })
   
    @popular.each.with_index do |v, i|
      vid = popularVids[i]

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
