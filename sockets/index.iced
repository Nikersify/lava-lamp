session = require '../middleware/session'

io = Lamp.io

# authentication
io.use (socket, next) ->
  session socket.request, {}, next

io.on 'connection', (socket) ->
  # check if user is logged in
  if 'user' of socket.request.session.passport
    # do magic
    global.debug = socket.request.session.passport.user
  else
    # require a nickname
    global.debug = 'nope'

  socket.emit 'ch',
    msg: 'siema'
