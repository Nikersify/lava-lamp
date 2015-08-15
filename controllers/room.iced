express = require 'express'
router = express.Router()

# r/:room
router.get '/:room', (req, res) ->
  res.render 'room',
    roomName: req.params.room
    user: req.userData

module.exports = router
