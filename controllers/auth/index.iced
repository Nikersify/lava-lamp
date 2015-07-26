express = require 'express'
router = express.Router()

router.use '/steam', require('./steam')

# login/
router.get '/', (req, res) ->
  res.render 'login'

module.exports = router
