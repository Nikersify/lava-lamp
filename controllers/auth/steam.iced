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
  profile.identifier = profile.provider + ':' + profile.id
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
  # TODO: cache avatars locally
  await user.hmset
    provider: 'steam'
    steamID: req.user.id
    nickname: req.user.displayName
    avatar: req.user.photos[2].value
  , defer err, reply
  res.redirect '/'

router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

module.exports = router
