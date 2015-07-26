express = require 'express'
router = express.Router()

# login/
router.use '/login', require('./auth')

# logout/
router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

# /
router.get '/', (req, res) ->
  res.render 'index', user: req.user

module.exports = router
