io = Lamp.io
session = require '../middleware/session'

# authentication
io.use (socket, next) ->
  session socket.request, {}, next

require './room'
