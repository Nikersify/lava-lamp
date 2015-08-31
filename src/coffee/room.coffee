roomNsp = io.connect(location.host+'/room')

# ghetto event
onYouTubeLoad = undefined

# socket events
roomNsp.on 'server message', (data) ->
  $('.serverMessages').append("<div class='serverMessage'>#{data.msg}</div>")

.on 'connect', (data) ->
  console.log 'Connected', data

.on 'require nickname', () ->
  roomNsp.emit 'send nickname',
    nickname: prompt 'Enter a nickname:'

.on 'ready', (data) ->
  console.log 'ready'
  roomNsp.emit 'handshake',
    # ikr
    room: /.+?\/(?:r|room)\/([^\/\n\r?]+)\/?/.exec(location.href)[1]

.on 'handshake success', (data) ->
  room = data.room
  user = data.user
  nowPlaying = data.nowPlaying

  if youtube.data.loaded
    youtube.player.loadVideoById
      videoId: data.id
      startSeconds: moment().unix() - data.requestedAt
  else
    onYouTubeLoad = ->
      youtube.player.loadVideoById
        videoId: data.nowPlaying.id
        startSeconds: moment().unix() - parseInt(data.nowPlaying.requestedAt)
      onYouTubeLoad = undefined

.on 'server error', (data) ->
  alert data.msg

.on 'fiesta', (data) ->
  console.log 'data', data
  if currentPlayer.name == 'youtube'
    switch data.type
      when 'alter video'
        youtube.player.loadVideoById data.id
        youtube.data.playing = true
      when 'pause'
        youtube.player.pauseVideo()
        youtube.data.playing = false
      when 'play'
        youtube.player.playVideo()
        youtube.data.playing = true

# player loading

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

youtube =
  player: undefined
  name: 'youtube'
  data:
    playing: false
    loaded: false

# youtube player events
youtube.events =
  onPlayerReady: (event) ->
    if onYouTubeLoad?()
      onYouTubeLoad()

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
      # iOS player not going fullscreen setting
      playsinline: 1
    events:
      'onReady': youtube.events.onPlayerReady
      'onStateChange': youtube.events.onPlayerStateChange

  youtube.data.loaded = true


# DOM events

$('#videoIdSubmit').click (e) ->
  id = $('#videoIdInput').val()

  # regex isn't that bad afterall
  regex = /(?:(?:v=)|(?:v\/)|youtu\.be\/)([^&\s#]+)/
  matches = regex.exec(id)
  console.log matches
  try
    if matches?
      roomNsp.emit 'fiesta',
        type: 'alter video'
        data:
          id: matches[1]
      $('#videoIdInput').val('')
    else
      throw Error('Incorrect video ID')

  catch error
    $('#videoIdInput').val(error)


$('#playPauseBtn').click (e) ->
  if currentPlayer.data.playing is true
    roomNsp.emit 'fiesta',
      type: 'pause'
  else if currentPlayer.data.playing is false
    roomNsp.emit 'fiesta',
      type: 'play'

$('#volumeRange').change (e) ->
  if currentPlayer.name is 'youtube'
    currentPlayer.player.setVolume $(this).val()

# initialize!

currentPlayer = youtube
loadPlayer('youtube')
