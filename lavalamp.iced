# hello

iced = require('iced-coffee-script').iced
global.iced = iced

express = require 'express'
passport = require 'passport'
redis = require 'redis'
repl = require 'repl'
session = require 'express-session'
User = require './models/User'

RedisStore = require('connect-redis')(session)

app = express()

# load config, crash if not present
config = require('./utils/config')

Lamp =
  config: config

global.Lamp = Lamp;

console.log "Attempting a connection to Redis at #{Lamp.config.redis.host}:#{Lamp.config.redis.port}"
await Lamp.Database = redis.createClient Lamp.config.redis.port, Lamp.config.redis.host, Lamp.config.redis.options
console.log "Connected to Redis"
await Lamp.Database.select Lamp.config.redis.db
console.log "Selected db #{Lamp.config.redis.db}"

passport.serializeUser (user, done) ->
  done null, user.identifier
passport.deserializeUser (identifier, done) ->
  await User.getOrCreate identifier, defer user
  done null, user

app.use session
  store: new RedisStore
    client: Lamp.Database
    db: Lamp.config.redis.db
  secret: Lamp.config.server.secret
  resave: false
  saveUninitialized: false

app.use passport.initialize()
app.use passport.session()

app.set 'view engine', 'jade'
app.use express.static __dirname + '/public'
app.use require './middleware/auth'
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
