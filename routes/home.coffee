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
  doc = req.user
  arr = {
    id: doc.history.length + 1
    text: req.query.news
  }
  doc.history.push(arr)
  res.send(doc.history)


module.exports = router