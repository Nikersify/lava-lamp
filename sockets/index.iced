session = require '../middleware/session'
User = require '../models/User'
io = Lamp.io

# authentication
io.use (socket, next) ->
  session socket.request, {}, next

io.on 'connection', (socket) ->
  global.debug = socket
  # check if user is logged in
  if 'user' of socket.request.session.passport
    # do magic
    user = new User socket.request.session.passport.user
    await user.hgetall defer err, userinfo
    console.log userinfo
    msg = "Logged in as #{userinfo.nickname}"
  else
    # require a nickname
    msg = 'Not logged in'

  socket.emit 'server info',
    msg: msg
