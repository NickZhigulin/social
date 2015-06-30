socketio = require('socket.io')
io = false
exports.boot = (server) ->
  io = socketio server

  io.on 'connection', (socket) ->
    console.log('connection')
    socket.on 'subscribe', (data) ->
      socket.join(data._id);



exports.getIo = () -> io;