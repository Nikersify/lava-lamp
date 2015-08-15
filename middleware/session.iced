session = require 'express-session'
RedisStore = require('connect-redis')(session)

module.exports = session
  store: new RedisStore
    client: Lamp.Database
    db: Lamp.config.redis.db
  secret: Lamp.config.server.secret
  resave: false
  saveUninitialized: false
