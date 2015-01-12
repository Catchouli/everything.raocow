function resizeVideos()
{
  var videos = $(".videoapplet");
  
  videos.each(function()
  {
    $(this).height($(this).width() * (9.0/16.0));
  });
}

// Do it to start with, and then when the window is resized
resizeVideos();
$(window).resize(resizeVideos);