mongoose = require('mongoose')
_ = require('underscore')
ObjectId = mongoose.Schema.Types.ObjectId



schema = new mongoose.Schema(
    player1:
        type: ObjectId
        ref: 'User'
    player2:
        type: ObjectId
        ref: 'User'
    player1color:String
    player2color:String
    board: []
    figures: []
    status: String
    step: String
    history: []
    created_at:
        type: Date
        default: Date.now
)

Game = mongoose.model('Game', schema);


Game.defaultFigures = [
    {
        id:0
        x: 1
        y: 0
        type: 'horse'
        color: 'white'
    }
    {
        id:1 
        x: 6 
        y: 0 
        type: 'horse' 
        color: 'white'
    }
    {
        id:2 
        x: 1 
        y: 7 
        type: 'horse' 
        color: 'black'
    }
    {
        id:3 
        x: 6 
        y: 7 
        type: 'horse' 
        color: 'black'
    }
    {
        id:4 
        x: 0 
        y: 0 
        moved: false 
        color: 'white' 
        type: 'rook'
    }
    {
        id:5 
        x: 7 
        y: 0 
        moved: false 
        color: 'white' 
        type: 'rook'
    }
    {
        id:6 
        x: 0 
        y: 7 
        moved: false 
        color: 'black' 
        type: 'rook'
    }
    {
        id:7 
        x: 7 
        y: 7 
        moved: false 
        color: 'black' 
        type: 'rook'
    }
    {
        id: 8 
        x: 2 
        y: 0 
        color: 'white' 
        type: 'bishop'
    }
    {
        id: 9 
        x: 5 
        y: 0 
        color: 'white' 
        type: 'bishop'
    }
    {
        id: 10 
        x: 2 
        y: 7 
        color: 'black' 
        type:  'bishop'
    }
    {
        id: 11 
        x: 5 
        y: 7 
        color: 'black' 
        type:  'bishop'
    }
    {
        id: 12 
        x: 4 
        y: 0 
        color: 'white' 
        type:  'queen'
    }
    {
        id: 13 
        x: 4 
        y: 7 
        color: 'black' 
        type: 'queen'
    }
    {
        id: 14 
        x: 3 
        y: 0 
        moved: false 
        death: false 
        color: 'white' 
        type:  'king'
    }
    {
        id: 15 
        x: 3 
        y: 7 
        moved: false 
        death: false 
        color: 'black' 
        type:  'king'
    }
    {
        id: 16 
        x: 0 
        y: 1 
        color: 'white' 
        type: 'pawn'
    }
    {
        id: 17
        x: 1
        y:1
        color: 'white'
        type: 'pawn'
    }
    {
        id: 18 
        x: 2 
        y: 1 
        color: 'white' 
        type: 'pawn'
    }
    {
        id: 19 
        x: 3 
        y: 1 
        color: 'white' 
        type: 'pawn'
    }
    {
        id: 20 
        x: 4 
        y: 1 
        color: 'white' 
        type: 'pawn'
    }
    {
        id: 21 
        x: 5 
        y: 1 
        color: 'white' 
        type: 'pawn'
    }
    {
        id: 22 
        x: 6 
        y: 1 
        color: 'white' 
        type: 'pawn'
    }
    {
        id: 23 
        x: 7 
        y: 1 
        color: 'white' 
        type: 'pawn'
    }
    {
        id: 24 
        x: 0 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }
    {
        id: 25 
        x: 1 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }
    {
        id: 26 
        x: 2 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }
    {
        id: 27 
        x: 3 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }
    {
        id: 28 
        x: 4 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }
    {
        id: 29 
        x: 5 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }
    {
        id: 30 
        x: 6 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }
    {
        id: 31 
        x: 7 
        y: 6 
        color: 'black' 
        type: 'pawn'
    }]

module.exports = Game
