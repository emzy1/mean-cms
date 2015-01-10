jwt      = require "jsonwebtoken"
User     = require "../models/user"
config  =  require "../config"

module.exports = (req, res, next) ->
  User.findOne email: req.body.email, (err, user) ->
    if err
      next err
    else if user and user.authenticate req.body.password
      token = jwt.sign user.user_info, config.secret
      res.json token: token
    else
      next new Error "Incorrect username or password"
