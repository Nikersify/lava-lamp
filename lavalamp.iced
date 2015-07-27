# hello

express = require 'express'
repl = require 'repl'
passport = require('passport')
session = require('express-session')
redis = require 'redis'
RedisStore = require('connect-redis')(session)

app = express()

# load config
config = require('./utils/config')

Lamp =
  config: config
  Database: redis.createClient()

global.Lamp = Lamp;


passport.serializeUser (user, done) ->
  done null, user
passport.deserializeUser (obj, done) ->
  done null, obj

app.use session
  store: new RedisStore
    client: Lamp.Database
    db: 1
  secret: Lamp.config.server.secret

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
