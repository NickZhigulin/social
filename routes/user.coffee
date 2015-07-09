express = require('express')
multer = require('multer')
models = require('../lib/db').models
auth = require('../lib/auth')
router = express.Router()

router.get '/', auth.auth, (req,res, next) ->
  console.log(req.query)
  res.redirect '/user/'+req.query.name


router.get '/:nickname', auth.auth, (req,res) ->
  res.render 'user'
module.exports = router