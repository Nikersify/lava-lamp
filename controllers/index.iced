express = require 'express'
router = express.Router()

router.use '/login', require('./auth')

# /
router.get '/', (req, res) ->
  res.render 'index', user: req.user

module.exports = router
