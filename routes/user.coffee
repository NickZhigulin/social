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
      }
      data.friend = 'Add friend' if !user.friends.length
      user.friends.forEach (el) ->
        console.log "el",el,"req.params.nickname",req.params.nickname
        data.friend = 'Delete friend' if el.name == req.params.nickname
        data.friend = 'Add friend' if el.name != req.params.nickname
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
  }
  models.Chat.find { id: chat.id }, (err, model) ->
    if !model.length
      models.Chat.create chat, (err, doc) ->
  models.User.findOne {nickname: req.user.nickname}, (err,user) ->
    user.chatrooms.push chat if !user.chatrooms.length
    user.chatrooms.filter (el) ->
      if el.name == req.params.nickname
        return true
      else
        user.chatrooms.push chat
        return true
    user.markModified("chatrooms")
    user.save (err) ->
  models.User.findOne {nickname: req.params.nickname}, (err,user) ->
    chat.name = req.user.nickname
    user.chatrooms.push chat if !user.chatrooms.length
    user.chatrooms.filter (el) ->
      console.log("el",el)
      if el.name == req.user.nickname
        return true
      else
        user.chatrooms.push chat
        return true
    user.markModified("chatrooms")
    user.save (err) ->
      res.send()


module.exports = router