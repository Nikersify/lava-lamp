class module.exports
  constructor: (@identifier) ->

  get: (key, callback) ->
    await Lamp.Database.hget "user:#{@identifier}", key, defer err, reply
    callback? err, reply

  set: (key, value, callback) ->
    await Lamp.Database.hset "user:#{@identifier}", key, value, defer err, reply
    callback? err, reply

  hmset: (obj, callback) ->
    await Lamp.Database.hmset "user:#{@identifier}", obj, defer err, reply
    callback? err, reply

  hgetall: (callback) ->
    await Lamp.Database.hgetall "user:#{@identifier}", defer err, obj
    callback? err, obj

  @getOrCreate: (identifier, callback) ->
    await Lamp.Database.exists "user:#{identifier}", defer err, userExists
    # TODO: createdAt time
    if userExists
      callback new @ identifier
    else
      callback new @ identifier
