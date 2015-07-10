express = require('express')
multer = require('multer')
models = require('../lib/db').models
auth = require('../lib/auth')
router = express.Router()

router.get '/:nickname', auth.auth, (req,res) ->
  console.log("vxcvxzcvzxcvz", req.params.nickname)
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
      user.friends.filter (el) ->
        if el == req.params.nickname
           data.friend = 'Delete friend'
           return true
        else
           data.friend = 'Add friend'
           return true
      res.send(data)

router.get '/:nickname/friend', auth.auth, (req,res) ->
  models.User.findOne {nickname: req.user.nickname}, (err,user) ->
    models.User.findOne {nickname: req.params.nickname}, (err,friend) ->
      user.friends.push(friend.nickname)
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
        return el != req.params.nickname
      )
      data = {
        friend:'Add friend'
      }
      user.markModified('friends')
      user.save (err) ->
        res.send(data)

module.exports = router