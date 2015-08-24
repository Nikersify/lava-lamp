User = require '../models/User'
Room = require '../models/Room'
io = Lamp.io

room = io.of('/room')

room.on 'connection', (socket) ->
  global.debug = socket

  socket.data =
    user: {}

  # if user is logged in
  if socket.request.session?.passport?.user?
    socket.data.auth = true

    user = new User socket.request.session.passport.user
    await user.hgetall defer err, userinfo
    socket.emit 'server message',
      msg: "Logged in as #{userinfo.nickname}, using #{userinfo.provider}."

    socket.data.user = userinfo
  else
    socket.data.auth = false
    # require a nickname
    socket.emit 'server message',
      msg: 'Not logged in, requiring a nickname.'
    socket.emit 'require nickname'
    socket.once 'send nickname', (data) ->
      socket.data.user.nickname = data.nickname
      socket.data.ready = true

  socket.on 'handshake', (data) ->
    console.log 'DATAROOM', data.room
