// Initialise google apis
function onClientLoad(event)
{
  console.log("gapi client loaded");

  gapi.client.setApiKey('AIzaSyBojm1VfsUMi5DQnW2VtxvZpuN0Pq03Teg');
  gapi.client.load('youtube', 'v3', updateVideoDescription);
}

// Load iframe api asyncronously
var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// Seek to video time
function seekTo(time)
{
  var splitTime = time.split(':')
  
  var hours = 0;
  var minutes = 0;
  var seconds = 0;

  if (splitTime.length == 1)
  {
    seconds = parseInt(splitTime[0]);
  }
  else if (splitTime.length == 2)
  {
    minutes = parseInt(splitTime[0]);
    seconds = parseInt(splitTime[1]);
  }
  else if (splitTime.length == 3)
  {
    hours = parseInt(splitTime[0]);
    minutes = parseInt(splitTime[1]);
    seconds = parseInt(splitTime[2]);
  }
  else
  {
    return false;
  }

  console.log("seeking to: " + hours + ":" + minutes + ":" + seconds);

  player.seekTo(hours * 3600 + minutes * 60 + seconds);

  return false;
}

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
    console.log(response);

    var description = response.items[0].snippet.description;

    // Replace linebreaks with <br> and add time index links
    description = description.replace(/\n/g, '<br>')
                    .replace(/(\d+\:\d+(?::\d+)?)/g, '<a href="#" onClick="seekTo(\'$1\')">$1</a>')

    // Auto linkify links
    description = Autolinker.link(description);

    // Add title
    description = '<h2>' + response.items[0].snippet.title + '</h2>' + description;

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
