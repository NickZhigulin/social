express = require('express')
multer = require('multer')
models = require('../lib/db').models
auth = require('../lib/auth')
router = express.Router()

router.get '/', auth.auth, (req,res, next) ->
  res.render 'alboms'

router.get '/user', auth.auth, (req, res, next) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    data={
      user:
        nickname:doc.nickname
        avatar: doc.avatar
      albom:doc.albom
    }
    res.send(data)

router.get '/newAlbom', auth.auth, (req,res,next) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    time = new Date()
    id = new Date()
    id = id.setTime(time.getTime())
    albom = {
      id:id
      name:req.query.name
    }
    doc.albom.push(albom)
    doc.markModified("albom")
    doc.save (err) ->
      res.send(doc.albom)

router.post '/close/albom', auth.auth, (req,res) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    doc.albom = doc.albom.filter (el) ->
      return el.name != req.body.name
    doc.markModified("albom")
    doc.save (err) ->
      res.redirect '/alboms'

router.post '/close/picture', auth.auth, (req,res) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    console.log "sfsdfsdf"
    doc.albom.filter((el) ->
      if el.name == req.body.albom
        el.picture = el.picture.filter((el2) ->
          el2.name != req.body.name
        )
      return
    )
    doc.markModified("albom")
    doc.save (err) ->
        res.send(doc.albom)

router.get '/', (req, res, next) ->
  res.sendfile "alboms"

router.use multer(
  dest: './public/img/alboms/'
  time = new Date()
  id = new Date()
  id = id.setTime(time.getTime())
  rename: (fieldname, filename,req) ->
    req.user.nickname+id
  onFileUploadStart: (file) ->
    console.log file.originalname + ' is starting ...'
    return
  onFileUploadComplete: (file) ->
    console.log file.fieldname + ' uploaded to  ' + file.path
    done = true
    return
)

router.post '/upload/:name', auth.auth, (req,res) ->
  models.User.findOne {nickname:req.user.nickname}, (err, doc) ->
    pic = {
      name:req.files.picture.name
      picture:"/img/alboms/"+req.files.picture.name
    }
    doc.albom.forEach((el) ->
      el.picture = [ ] if !el.picture
      el.picture.push(pic) if el.name==req.params.name
    )
    doc.markModified('albom')
    doc.save (err) ->
      res.redirect '/alboms'




module.exports = router