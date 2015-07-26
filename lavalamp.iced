# hello

express = require 'express'
repl = require 'repl'
passport = require('passport')
session = require('express-session')

app = express()

# load config
config = require('./utils/config')

Lamp =
  config: config

global.Lamp = Lamp;


passport.serializeUser (user, done) ->
  done null, user
passport.deserializeUser (obj, done) ->
  done null, obj

ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    next(null)
  else
    res.redirect '/login'

app.use session secret: Lamp.config.server.secret
app.use passport.initialize()
app.use passport.session()

app.set('view engine', 'jade')
app.use express.static __dirname + '/public'
app.use require './controllers'

server = app.listen 3000, ->
  console.log 'listening on port 3000'

r = repl.start
  prompt: 'Lava Lamp> '
  useGlobal: true

r.context.Lamp = Lamp

r.on 'exit', ->
  console.log '\nTerminating...'
  process.exit()
