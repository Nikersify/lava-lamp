checkAuth = require '../middleware/checkAuth'
express = require 'express'
moment = require 'moment'
Room = require '../models/Room'
router = express.Router()

# r/create
router.post '/create', checkAuth, (req, res) ->
  room_name = req.body.room_name

  # room name regulationzz

  # can't be undefined
  if !room_name?
    return res.render 'error',
      error:
        msg: 'Something went wrong...'

  # can't be empty
  if room_name == ''
    return res.render 'error',
      error:
        msg: 'You have to specify a room name!'

  # no spaces / %20
  console.log "room_name #{room_name}"
  if room_name.indexOf(' ') > -1
    return res.render 'error',
      error:
        msg: "Can't have any white characters in the room name."

  room = new Room room_name

  # can't already exist
  await room.exists defer err, exists
  if exists == 1
    return res.render 'error',
      error:
        msg: 'Room with that name does already exists :('

  await room.hmset
    name: room_name
    createdAt: moment().unix()
    owner: req.userData.identifier
  , defer err, reply

  res.redirect "/room/#{room_name}"

# r/:room
router.get '/:room', (req, res) ->
  room = new Room req.params.room
  await room.exists defer err, exists
  if exists == 1
    res.render 'room',
      roomName: req.params.room
      user: req.userData
  else
    res.render 'error',
      error:
        msg: 'This room does not exist! :('

module.exports = router
