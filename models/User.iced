class module.exports
  constructor: (@id, @loginType, @loginID) ->

  exists: ->
    await Lamp.Database.exists "user:#{@id}", defer err, reply
    if err?
      console.error 'Something went wrong'
    if reply == 1
      return true
    else
      return false

  setProp: (key, value) ->
    await Lamp.Database.hset "user:#{@id}", key, value, defer err, reply
    if reply == '1' then true else false

  getProp: (key) ->
    await Lamp.Database.hget "user:#{@id}", key, defer err, reply
    reply

  @getOrCreate: (id, loginType, loginID, cb) ->
    await Lamp.Database.exists "user:#{id}", defer err, userExists
    if !userExists # 0/1
      await Lamp.Database.hget "user:steamids", loginID, defer err, IDexists
      if IDexists?
        id = IDexists
        console.log "old steam user #{loginID} #{id}"
      else
        # new user
        await Lamp.Database.incr 'next_user_id', defer err, nextID
        console.log 'NEXTID', nextID
        id = nextID
        console.log 'loginType', loginType
        if loginType? and loginType == 'steam'
          Lamp.Database.hset 'user:steamids', loginID, id
          console.log "new steam user #{loginID} #{id}"
    cb new @ id, loginType, loginID
