express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
mongoose = require('mongoose')
session = require('express-session')
auth = require('./lib/auth')
socket = require('./lib/socket')
http = require('http')


index = require('./routes/index')
home = require('./routes/home')
user = require('./routes/user')
chat = require('./routes/chat')
friends = require('./routes/friends')
alboms = require('./routes/alboms')
news = require('./routes/news')

mongoose.connect('mongodb://127.0.0.1/test')

db = mongoose.connection



app = express()
app.set("views", path.join(__dirname, "views"))
app.set('view engine', 'jade')
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'public')))
app.use(session(
  secret: 'keyboard cat'
  resave: false
  saveUninitialized: true
  cookie:
    maxAge: 365 * 24 * 60 * 60
    httpOnly: false))
auth.init app
app.use('/', index)
app.use('/home', home)
app.use('/user',  user)
app.use('/chat', chat)
app.use('/friends', friends)
app.use('/alboms', alboms)
app.use('/news', news)
# catch 404 and forward to error handler
app.use (req, res, next) ->
  console.log "error: ", err
  err = new Error('Not Found')
  err.status = 404
  next err
  return
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    console.log "error: ", err
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err
    return
app.use (err, req, res, next) ->
  console.log "err:", err
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: err
  return

port = 3000
app.set 'port', port

###
 * Create HTTP server.
###

server = http.createServer(app);

###
 * Listen on provided port, on all network interfaces.
###

socket.boot server
##server.listen(port);
#server.on('error', () ->);
#server.on('listening', () ->
#  console.log "socket connect")
