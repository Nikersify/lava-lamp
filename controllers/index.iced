express = require 'express'
router = express.Router()

# r/
router.use '/r', require('./room')

# login/
router.use '/login', require('./auth')

# logout/
router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

# /
router.get '/', (req, res) ->
  res.render 'index', user: req.userData

module.exports = router
