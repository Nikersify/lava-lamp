module.exports = (req, res, next) ->
  if req.isAuthenticated()
    await req.user.hgetall defer err, obj
    req.user.all = obj
    next(err)
  else
    next(null)
