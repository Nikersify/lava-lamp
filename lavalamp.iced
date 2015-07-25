# hello

express = require 'express'
repl = require 'repl'

app = express()

# load config
config = require('./utils/config')

Lamp =
  config: config

global.Lamp = Lamp;

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
