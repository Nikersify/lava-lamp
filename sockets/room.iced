User = require '../models/User'
Room = require '../models/Room'
io = Lamp.io

room = io.of('/room')

room.on 'connection', (socket) ->
  socket.data =
    user: {}
    ready: false

  # if user is logged in
  if socket.request.session?.passport?.user?

    user = new User socket.request.session.passport.user
    await user.hgetall defer err, userinfo
    socket.emit 'server message',
      msg: "Logged in as #{userinfo.nickname}, using #{userinfo.provider}."

    socket.data.user = userinfo
    socket.data.ready = true

    socket.emit 'ready',
      user: socket.data.user
  else
  
    # require a nickname
    socket.emit 'server message',
      msg: 'Not logged in, requiring a nickname.'

    socket.emit 'require nickname'

    socket.once 'send nickname', (data) ->
      socket.data.user.nickname = data.nickname
      socket.data.ready = true

      socket.emit 'server message',
        msg: "Identifying as #{socket.data.user.nickname}."

      socket.emit 'ready',
        user: socket.data.user

  socket.on 'handshake', (data) ->
    console.log 'DATAROOM', data.room
