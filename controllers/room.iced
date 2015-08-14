express = require 'express'
router = express.Router()

# r/:room
router.get '/:room', (req, res) ->
  res.render 'room',
    room: req.params.room
    user: req.user

module.exports = router
