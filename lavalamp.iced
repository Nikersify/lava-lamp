# hello

iced = require('iced-coffee-script').iced
global.iced = iced

bodyParser = require 'body-parser'
express = require 'express'
morgan = require 'morgan'
passport = require 'passport'
redis = require 'redis'
repl = require 'repl'
User = require './models/User'

app = express()
server = require('http').Server(app)
io = require('socket.io')(server)

# load config, crash if not present
config = require('./utils/config')

Lamp =
  config: config
  io: io

global.Lamp = Lamp;

console.log "Attempting a connection to Redis at #{Lamp.config.redis.host}:#{Lamp.config.redis.port}"
await Lamp.Database = redis.createClient Lamp.config.redis.port, Lamp.config.redis.host, Lamp.config.redis.options
console.log "Connected to Redis"
await Lamp.Database.select Lamp.config.redis.db
console.log "Selected db #{Lamp.config.redis.db}"


app.use morgan('dev')

passport.serializeUser (user, done) ->
  done null, user.identifier
passport.deserializeUser (identifier, done) ->
  await User.getOrCreate identifier, defer user
  done null, user

app.use require './middleware/session'

app.use passport.initialize()
app.use passport.session()

app.use bodyParser.urlencoded extended: false
app.use bodyParser.json()

app.set 'view engine', 'jade'
app.use express.static __dirname + '/public'
app.use require './middleware/auth'
app.use require './controllers'

require './sockets'


server.listen 3000, ->
  console.log 'listening on port 3000'

r = repl.start
  prompt: 'Lava Lamp> '
  useGlobal: true

r.context.Lamp = Lamp

r.on 'exit', ->
  console.log '\nTerminating...'
  process.exit()
