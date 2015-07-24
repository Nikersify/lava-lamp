express = require 'express'
router = express.Router()

router.use '/', (req, res) ->
  res.render 'index'

module.exports = router
