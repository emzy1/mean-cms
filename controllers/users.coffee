jwt     = require "jsonwebtoken"
User    = require "../models/user"
config  = require "../config"

exports.create = (req, res, next) ->
  user = new User req.body
  user.save (err, user) ->
    if err
      next err
    else
      user = user.user_info
      user.token = jwt.sign user, config.secret, expiresInMinutes: 300
      res.json user

exports.index = (req, res, next) ->
  User.find (err, users) ->
    if err
      next err
    else
      res.json users.map (user) -> user.user_info
