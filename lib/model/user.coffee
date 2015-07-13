mongoose = require('mongoose')

schema = new mongoose.Schema
    email: String
    password: String
    nickname: String
    avatar: String
    friends: []
    history:[]
    news:[]
    chatrooms: []
    albom:
        number: Number
        name: String
        pictures: []
    created_at:
        type: Date
        default: Date.now


Model = mongoose.model('User', schema);

Model.register = (data, cb) ->

Model.defaultAvatar = "/img/upload/defaultAvatar.jpg"

Model.prototype.validPassword = (password, cb) ->
    return this.password == password

module.exports = Model