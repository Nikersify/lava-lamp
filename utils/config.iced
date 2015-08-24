cson = require 'cson'

configFile = 'config.cson'
config = {}
try
  config = cson.load configFile
catch err
  if err.code == 'ENOENT' # no file or directory
    console.log "'#{configFile}' (config) not found, edit and rename 'default.cson' to '#{configFile}'"
  else
    console.log err
  process.exit()

module.exports = config
