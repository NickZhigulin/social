mongoose = require('mongoose')

schema = new mongoose.Schema
  id: String
  name: String
  history: []


Chat = mongoose.model('Chat', schema);


module.exports = Chat
