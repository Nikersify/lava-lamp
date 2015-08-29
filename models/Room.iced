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

  addPrivileged: (user, callback) ->
    await Lamp.Database.sadd "room:#{@name}:privileged", user, defer err, reply
    callback? err, reply

  isPrivileged: (user, callback) ->
    await Lamp.Database.hget "room:#{@name}", 'private', defer err, isPrivate
    if isPrivate isnt "true"
      return callback? err, true

    await Lamp.Database.hget "room:#{@name}", 'owner', defer err, owner
    if owner = user
      return callback? err, true

    await Lamp.Database.sismember "room:#{@name}:privileged", user, defer err, reply
    if reply == 1
      callback? err, true
    else
      callback? err, false

  allPrivileged: (callback) ->
    await Lamp.Database.smembers "room:#{@name}:privileged", defer err, reply
    callback? err, reply

  countPrivileged: (callback) ->
    await Lamp.Database.scard "room:#{@name}:privileged", defer err, reply
    callback? err, reply

  removePrivileged: (user, callback) ->
    await Lamp.Database.srem "room:#{@name}:privileged", user, defer err, reply
    callback? err, reply

  create: (options, callback) ->
    await @hmset
      name: @name
      createdAt: moment().unix()
      owner: options.owner
      private: options.private
    , defer err, reply
    callback err, reply
