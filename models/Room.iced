moment = require 'moment'

class module.exports
  constructor: (@name) ->

  get: (key, callback) ->
    await Lamp.Database.hget "room:#{@name}", key, defer err, reply
    callback? err, reply

  set: (key, value, callback) ->
    await Lamp.Database.hset "room:#{@name}", key, value, defer err, reply
    callback? err, reply

  hmset: (obj, callback) ->
    await Lamp.Database.hmset "room:#{@name}", obj, defer err, reply
    callback? err, reply

  hgetall: (callback) ->
    await Lamp.Database.hgetall "room:#{@name}", defer err, obj
    callback? err, obj

  exists: (callback) ->
    await Lamp.Database.exists "room:#{@name}", defer err, obj
    callback? err, obj

  create: (options, callback) ->
    await @hmset
      name: @name
      createdAt: moment().unix()
      owner: options.owner
    , defer err, reply
    callback err, reply
