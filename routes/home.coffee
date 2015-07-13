express = require('express')
multer = require('multer')
models = require('../lib/db').models
auth = require('../lib/auth')
socket = require('../lib/socket')
router = express.Router()

router.get '/', auth.auth, (req,res, next) ->
  res.render 'home'

router.get '/user', auth.auth, (req, res, next) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    data={
      user:
        nickname:doc.nickname
        avatar: doc.avatar
      history:doc.history
      chatroom:doc.chatrooms
    }
    res.send(data)


router.get '/search',auth.auth, (req,res, next) ->
  models.User.find {"nickname" :req.query.name}, (err,doc) ->
    ssend = [{
        name:doc[0].nickname
        avatar:doc[0].avatar
        }] if doc.length
    res.send(ssend)

router.get '/history', auth.auth, (req, res, next) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    time = new Date()
    id = new Date()
    id = id.setTime(time.getTime())
    arr = {
      id:id
      text: req.query.mess
    }
    doc.history.push(arr)
    doc.markModified('history')
    doc.save (err) ->
      res.send(doc.history)

router.get '/close', auth.auth, (req,res,next) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    doc.history = doc.history.filter((el) ->
      return Number(el.id) != Number(req.query.id)
    )
    doc.markModified('history')
    doc.save (err) ->
      res.send(doc.history)

router.get '/', (req, res, next) ->
  res.sendfile "home"

router.use multer(
  dest: './public/img/upload/'
  rename: (fieldname, filename,req) ->
    req.user.nickname
  onFileUploadStart: (file) ->
    console.log file.originalname + ' is starting ...'
    return
  onFileUploadComplete: (file) ->
    console.log file.fieldname + ' uploaded to  ' + file.path
    done = true
    return
)
router.post '/avatar', (req,res) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    console.log("req.files",req.files.userPhoto.name)
    doc.avatar = "/img/upload/"+req.files.userPhoto.name
    doc.markModified('avatar')
    doc.save (err) ->
      socket.getIo().to(req.user.nickname).emit 'avatar', doc.avatar
      res.redirect '/home'


module.exports = router