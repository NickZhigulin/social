passport = require('passport')
LocalStrategy = require('passport-local').Strategy

models = require('./db').models


strategy = new LocalStrategy((email, password, done) ->
    models.User.findOne { email: email },  (err, user) ->
        if err
            return done(err)
        if !user
            return done(null, false)
        if !user.validPassword(password)
            return done(null, false)
        return done(null, user)
    return
)

passport.serializeUser((user, done) ->
    done(null, user)
)

passport.deserializeUser((id, done) ->
    done(null, id)
)
strategy._usernameField = 'email'
passport.use(strategy);

exports.init = (app) ->
    app.use(passport.initialize())
    app.use(passport.session())

exports.authenticate = passport.authenticate('local')
exports.auth = (req, res, next) ->
    if req.user
        next()
    else
        res.redirect '/'

exports.auth401 = (req,res,next) ->
    if req.user
        next()
    else
        res.sendStatus 401
