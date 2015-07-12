express = require('express')
multer = require('multer')
models = require('../lib/db').models
auth = require('../lib/auth')
socket = require('../lib/socket')
router = express.Router()

router.get '/', auth.auth, (req,res, next) ->
  res.render 'chat'

router.get '/rooms', auth.auth, (req,res) ->
  models.Chat.findOne {id:req.query.id},(err, doc) ->
    console.log("id",req.query.id, "doc", doc)
    res.send(doc.history)

router.get '/message',auth.auth, (req,res) ->
  models.Chat.findOne {id:req.query.id},(err, doc) ->
    console.log("doc",doc)
    data= {
      name:req.user.nickname
      text:req.query.message
    }
    console.log("data",data)
    doc.history = [] if doc.history == undefined
    doc.history.push(data)
    doc.markModified('history')
    doc.save (err) ->
      console.log doc.history
      socket.getIo().to(req.query.id).emit 'chat', doc.history
      res.send(doc.history)

module.exports = router