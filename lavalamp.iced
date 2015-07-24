# hello

express = require 'express'
repl = require 'repl'
cson = require 'cson'

app = express()

# load config
configFile = 'config.cson'
config = {}
try
  config = cson.load configFile
catch err
  if err.code == 'ENOENT' # no file or directory
    console.log "'#{configFile}' (config) not found, edit and rename 'defaultconfig.cson' to '#{configFile}'"
  else
    console.log err
  process.exit()

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
