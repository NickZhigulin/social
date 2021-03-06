express = require('express')
models = require('../lib/db').models
auth = require('../lib/auth')
socket = require('../lib/socket')
router = express.Router()

router.get '/', auth.auth, (req,res, next) ->
  res.render 'chat'

router.get '/rooms', auth.auth, (req,res) ->
  models.Chat.findOne {name:req.query.name},(err, doc) ->
    res.send(doc.history)

router.post '/message',auth.auth, (req,res) ->
  models.Chat.findOne {name:req.body.name},(err, doc) ->
    time = new Date()
    _data = time.getDate()+"."+time.getMonth()+"."+time.getFullYear()+"  "+time.getHours()+":"+time.getMinutes()
    data= {
      name:req.user.nickname
      text:req.body.message
      time:_data
    }
    doc.history = [] if doc.history == undefined
    doc.history.push(data)
    doc.markModified('history')
    doc.save (err) ->
      socket.getIo().to(req.body.id).emit 'chat', doc.history
      res.send(doc.history)

router.get '/activeChat', auth.auth, (req,res) ->
  models.User.findOne {nickname:req.user.nickname},(err, doc) ->
    doc.chatrooms.forEach((el)->
      models.Chat.findOne {name:el.name},(err, chat) ->
        console.log("el do:", el)
        el.active = false
        el.active = true if req.query.name == chat.name
        console.log("el after:", el)
        doc.markModified('chatrooms')
        doc.save (err) ->
    )
    console.log("doc :", doc.chatrooms)
    res.send()

module.exports = router