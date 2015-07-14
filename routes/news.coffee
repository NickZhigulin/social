express = require('express')
multer = require('multer')
models = require('../lib/db').models
auth = require('../lib/auth')
socket = require('../lib/socket')
_ = require('underscore')
router = express.Router()

router.get '/', auth.auth, (req,res, next) ->
  res.render 'news'

router.get '/user', auth.auth, (req, res, next) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    data={
      user:
        nickname:doc.nickname
        avatar: doc.avatar
      friends:doc.friends
      history:doc.history
    }
    res.send(data)

router.get '/news', auth.auth, (req,res, next) ->
    models.User.findOne {nickname: req.query.name}, (err , doc) ->
      res.send(doc)

router.get '/search',auth.auth, (req,res, next) ->
  models.User.find {"nickname" :req.query.name}, (err,doc) ->
    ssend = [{
        name:doc[0].nickname
        avatar:doc[0].avatar
        }] if doc.length
    res.send(ssend)


module.exports = router