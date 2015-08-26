room = io.connect(location.host+'/room')

room.on 'server message', (data) ->
  console.log data
  $('.serverMessages').append("<div class='serverMessage'>#{data.msg}</div>")

room.on 'require nickname', () ->
  room.emit 'send nickname',
    nickname: prompt('Enter a nickname:')

room.on 'connect', (data) ->
  room.emit 'handshake',
    # ikr
    room: /.+?\/(?:r|room)\/([^\/\n\r?]+)\/?/.exec(location.href)[1]

loadPlayer = (type) ->
  switch type
    when 'youtube'
      tag = document.createElement 'script'
      tag.src = 'https://www.youtube.com/iframe_api'

      firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore tag, firstScriptTag

      return true
    else
      return false

youtube = {}
youtube.player = undefined

# youtube player events
youtube.events =
  onPlayerReady: (event) ->
    #event.target.playVideo()

  onPlayerStateChange: (event) ->
    console.debug event

# youtube load callback
onYouTubeIframeAPIReady = ->
  youtube.player = new YT.Player 'youtube_player',
    height: '390'
    width: '640'
    #videoId: 'M7lc1UVf-VE'
    playerVars:
      controls: 0
      disablekb: 1
      rel: 0
    events:
      'onReady': youtube.events.onPlayerReady
      'onStateChange': youtube.events.onPlayerStateChange


loadPlayer('youtube')
