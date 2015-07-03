express = require('express')
multer = require('multer')
models = require('../lib/db').models
auth = require('../lib/auth')
router = express.Router()

router.get '/', auth.auth, (req,res, next) ->
  res.render 'home'

router.get '/user', auth.auth, (req, res, next) ->
  res.send(req.user)

router.get '/news', auth.auth, (req, res, next) ->
  models.User.findOne {nickname: req.user.nickname}, (err, doc) ->
    arr = {
      text: req.query.news
    }
    doc.history.push(arr)
    doc.markModified('history')
    doc.save (err) ->
      console.log "doc after: ", doc.history
      res.send(doc.history)


module.exports = router