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
