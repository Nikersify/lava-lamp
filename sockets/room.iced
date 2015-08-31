User = require '../models/User'
Room = require '../models/Room'
moment = require 'moment'
io = Lamp.io

room = io.of('/room')

room.on 'connection', (socket) ->
  socket.data =
    user: {}
    ready: false
    hands_shaken: false
    loggedIn: false

  # if user is logged in
  if socket.request.session?.passport?.user?

    user = new User socket.request.session.passport.user
    await user.hgetall defer err, userinfo
    socket.emit 'server message',
      msg: "Logged in as #{userinfo.nickname}, using #{userinfo.provider}."

    socket.data.user = userinfo
    socket.data.user.loggedIn = true
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
    if socket.data?.ready is true
      requestedRoom = new Room data.room
      await requestedRoom.hgetall defer err, roomData

      await requestedRoom.isPrivileged socket.data.user.identifier, defer err, isPrivileged

      if isPrivileged
        socket.join data.room

        socket.emit 'server message',
          msg: "Joined #{data.room}."

        await requestedRoom.getPlaying defer err, nowPlaying
        console.log 'now playing', nowPlaying
        socket.emit 'handshake success',
          room: roomData
          user: socket.data.user
          nowPlaying: nowPlaying

        socket.data.room = requestedRoom
        socket.data.roomName = data.room

        socket.data.hands_shaken = true

      else
        socket.emit 'server message',
          msg: "Hey wait, you shouldn't be here!"

        socket.emit 'server error',
          msg: "Unauthorized."

  socket.on 'fiesta', (data) ->
    if socket.data.hands_shaken

      await socket.data.room.get 'moderated', defer err, reply
      if reply isnt 'true' or socket.data.roomData.owner is socket.data.user.identifier

        switch data.type
          when 'alter video'

            # TODO: validate id

            if socket.data.user.loggedIn == true
              tmpIdentifier = socket.data.user.identifier
            else
              tmpIdentifier = socket.data.user.nickname

            await socket.data.room.setPlaying
              id: data.data.id
              requestedBy: tmpIdentifier
              requestedAt: moment().unix()
              loggedIn: socket.data.user.loggedIn
            , defer err, reply

            room.to(socket.data.roomName).emit 'fiesta',
              type: 'alter video'
              id: data.data.id
              requestedBy: tmpIdentifier
              requesterLoggedIn: socket.data.user.loggedIn

          when 'play'
            room.to(socket.data.roomName).emit 'fiesta',
              type: 'play'

          when 'pause'
            room.to(socket.data.roomName).emit 'fiesta',
              type: 'pause'
