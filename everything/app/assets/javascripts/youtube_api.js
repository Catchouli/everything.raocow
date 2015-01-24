var re_weburl = new RegExp(
    // protocol identifier
    "((?:(?:https?|ftp)://)" +
    // user:pass authentication
    "(?:\\S+(?::\\S*)?@)?" +
    "(?:" +
      // IP address exclusion
      // private & local networks
      "(?!(?:10|127)(?:\\.\\d{1,3}){3})" +
      "(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})" +
      "(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})" +
      // IP address dotted notation octets
      // excludes loopback network 0.0.0.0
      // excludes reserved space >= 224.0.0.0
      // excludes network & broacast addresses
      // (first & last IP address of each class)
      "(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])" +
      "(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}" +
      "(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))" +
    "|" +
      // host name
      "(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)" +
      // domain name
      "(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*" +
      // TLD identifier
      "(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))" +
    ")" +
    // port number
    "(?::\\d{2,5})?" +
    // resource path
    "(?:/\\S*)?)"
);

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
    var description = response.items[0].snippet.description;

    description = description.replace(/\n/g, '<br>')
                    .replace(/\b(([\w-]+:\/\/?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([\w\s]|\/)))/g, '<a href="$1">$1</a>')
                    .replace(/(\d+\:\d+(?::\d+)?)/g, '<a href="#" onClick="seekTo(\'$1\')">$1</a>')

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
