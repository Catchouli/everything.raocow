// Initialise google apis
gapi.client.setApiKey('AIzaSyBojm1VfsUMi5DQnW2VtxvZpuN0Pq03Teg');
gapi.client.load('youtube', 'v3', updateVideoDescription);

// Load iframe api asyncronously
var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// Update video description
function updateVideoDescription()
{
  // Return if the youtube or player apis haven't loaded yet
  // (this will be called when they are)
  if (gapi.client.youtube == null ||
      typeof player === 'undefined')
  {
    return;
  }

  video_id = player.getVideoData()['video_id'];

  gapi.client.youtube.videos.list({id: video_id, part: 'snippet'}).execute(function(response)
  {
    var description = response.items[0].snippet.description;

    description = description.replace(/\n/g, '<br>').replace(/(\A|[^=\]\'"a-zA-Z0-9])(http[s]?:\/\/(.+?)\/[^()<>\s]+)/g, '$1<a href="$2">$2</a>')

    console.log("description: " + description);

    $('#homevideo-description').html(description);
    $('#homevideo-description-container').css('display', 'block');
  });    
}

var player;
if ($('#homevideo').length > 0)
{
  // Cue videos
  function onPlayerReady(event)
  {
    var videos = $('#homevideo').data('videos').split(',');

    player.cuePlaylist(videos);
  }

  // Wait for video applet to load
  function onPlayerStateChange(event)
  {
    // When a video is loaded
    if (event.data == -1)
    {
      video_id = player.getVideoData()['video_id'];
      console.log("loaded video: " + video_id);
      updateVideoDescription();
    }
  }

  // Create youtube player object and register events
  function onYouTubeIframeAPIReady()
  {
    console.log("iframe api ready");

    player = new YT.Player('homevideo', {
      videoId: $('#homevideo').data('videos').split(',')[0],
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange
      }
    });
  }
}
