express = require 'express'
passport = require 'passport'
router = express.Router()
SteamStrategy = require('passport-steam').Strategy
User = require('../../models/User')

passport.use new SteamStrategy
  apiKey: Lamp.config.steam.apikey
  returnURL: 'http://localhost:3000/login/steam/return'
  realm: 'http://localhost:3000/'
, (identifier, profile, done) ->
  profile.identifier = identifier
  console.log "PROFILE", profile
  done null, profile

# login/steam/
router.get '/',
passport.authenticate('steam', failureRedirect: '/login'),
(req, res) ->
  res.redirect '/'

# login/steam/return
router.get '/return',
passport.authenticate('steam', failureRedirect: '/login'),
(req, res) ->
  await User.getOrCreate req.user.identifier, defer user
  console.log "CALLED DEBUG"
  await user.set 'provider', 'steam', defer err, reply
  await user.set 'steamID', req.user.id, defer err, reply
  await user.set 'nickname', req.user.displayName, defer err, reply
  # TODO: cache avatars locally
  await user.set 'avatar', req.user.photos[2].value, defer err, reply # highest resolution

  res.redirect '/'

router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

module.exports = router
