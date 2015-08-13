module.exports = (req, res, next) ->
  if req.isAuthenticated()
    next null
  else
    res.redirect '/login'
