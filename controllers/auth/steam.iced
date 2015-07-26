express = require 'express'
router = express.Router()
passport = require 'passport'
SteamStrategy = require('passport-steam').Strategy

passport.use new SteamStrategy
  apiKey: Lamp.config.steam.apikey
  returnURL: 'http://localhost:3000/login/steam/return'
  realm: 'http://localhost:3000/'
, (identifier, profile, done) ->
  profile.identifier = identifier
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
  res.redirect '/'

router.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

module.exports = router
