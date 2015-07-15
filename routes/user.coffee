express = require('express')
models = require('../lib/db').models
auth = require('../lib/auth')
router = express.Router()

router.get '/:nickname', auth.auth, (req,res) ->
  res.render 'user'

router.get '/:nickname/data', auth.auth, (req,res) ->
  models.User.findOne {nickname: req.params.nickname}, (err, doc) ->
    models.User.findOne {nickname: req.user.nickname}, (err, user) ->
      data={
        user:
          nickname:doc.nickname
          avatar: doc.avatar
        history:doc.history
        friend:"Add friend"
      }
      user.friends.forEach (el) ->
        data.friend = 'Delete friend' if el.name == req.params.nickname
      res.send(data)

router.get '/:nickname/friend', auth.auth, (req,res) ->
  models.User.findOne {nickname: req.user.nickname}, (err,user) ->
    models.User.findOne {nickname: req.params.nickname}, (err,friend) ->
      name={
        name:friend.nickname
        avatar:friend.avatar
      }
      user.friends.push(name)
      user.markModified('friends')
      data = {
        friend:'Delete friend'
      }
      user.save (err) ->
        res.send(data)

router.get '/:nickname/delete', auth.auth, (req,res) ->
  models.User.findOne {nickname: req.user.nickname}, (err,user) ->
    models.User.findOne {nickname: req.params.nickname}, (err,friend) ->
      user.friends = user.friends.filter((el) ->
        return el.name != req.params.nickname
      )
      data = {
        friend:'Add friend'
      }
      user.markModified('friends')
      user.save (err) ->
        res.send(data)

router.get '/:nickname/chat', auth.auth, (req,res) ->
  time = new Date()
  id = new Date()
  id = id.setTime(time.getTime())
  chat = {
    id:id
    name: req.params.nickname
    active: false
  }
  models.Chat.find { name: chat.name }, (err, model) ->
    if !model.length
      models.Chat.create chat, (err, doc) ->
  count = 0
  models.User.findOne {nickname: req.user.nickname}, (err,user) ->
    user.chatrooms.push chat if !user.chatrooms.length
    user.chatrooms.forEach((el) ->
      count++ if el.name == req.params.nickname
    )
    user.chatrooms.push(chat) if !count
    user.markModified("chatrooms")
    user.save (err) ->
  count = 0
  models.User.findOne {nickname: req.params.nickname}, (err,user) ->
    chat.name = req.user.nickname
    user.chatrooms.push chat if !user.chatrooms.length
    user.chatrooms.filter((el) ->
      count++ if el.name == req.user.nickname
    )
    user.chatrooms.push chat if !count
    user.markModified("chatrooms")
    user.save (err) ->
      res.send()


module.exports = router