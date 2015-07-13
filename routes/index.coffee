express = require('express')
models = require('../lib/db').models
auth = require('../lib/auth')
router = express.Router()

router.get '/',(req, res, next) ->
  res.render 'index'

router.post '/', auth.authenticate,(req, res) ->
  res.redirect '/home',


router.get '/registration', (req, res, next)->
  res.render 'registration'

router.post '/registration',  (req, res) ->
  user = req.body;
  user.avatar = models.User.defaultAvatar
  if user.password isnt user.passwordRepeat
    return res.sendStatus(400)
  models.User.create user, (err, doc) ->
    res.render 'index'





module.exports = router