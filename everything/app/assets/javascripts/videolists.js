var videos = $('.video-list > .item');

videos.each(function()
{
  var thumbnail = $(this).find('a > .thumbnail');
  var info = $(this).find('a > .info');
  
  var video_id = $(this).data('video-id');

  if (video_id != undefined)
  {
    // Set thumbnail url
    var thumbnail_url = 'https://i1.ytimg.com/vi/' + video_id + '/mqdefault.jpg';
    thumbnail.css("background-image", "url(" + thumbnail_url + ")");
  } 
 
  // Make thumbnails 16:9
  function resizeThumb()
  {
    var thumb = $('.video-list > .item > a > .thumbnail');
    thumb.height(thumb.width() * (9.0/16.0));
  }
  
  // Set up event
  $(document).on('load page:change', resizeThumb);
  $(window).resize(resizeThumb);
});

// Make all video lists the same size
function resizeVideoListItems()
{
  var maxHeight = 0;

  videos.each(function()
  {
    // Check for max height
    $(this).height('auto');
    var height = $(this).height();
    if (height > maxHeight)
      maxHeight = height;
  });

  videos.height(maxHeight);
}

$(document).on('load page:change', resizeVideoListItems);
$(window).resize(resizeVideoListItems);
