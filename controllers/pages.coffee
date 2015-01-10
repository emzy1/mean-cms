Page = require "../models/page"

exports.index = (req, res, next) ->
  Page.find (err, obj) ->
    if err
      next err
    else if obj
      res.json obj
    else
      next()

exports.get = (req, res, next) ->
  if req.params.id
    Page.findById req.params.id, (err, page) ->
      if err
        next err
      else if page
        res.json page
      else
        next()

  else
    Page.findOne path: "/#{req.params.path}", (err, page) ->
      if err
        next err
      else if page
        res.render "templates/layout", page
      else
        next()

exports.home = (req, res, next) ->
  if req.params.id
    Page.findById req.params.id, (err, obj) ->
      if err
        next err
      else if obj
        res.json obj
      else
        next()
  else
    Page.findOne path: "home", (err, obj) ->
      if err
        next err
      else if obj
        res.render "pages/render", obj
      else
        next()

exports.delete = (req, res, next) ->
  Page.findById req.params.id, (err, page) ->
    if err then next err else page.remove (err, obj) ->
      if err
        next err
      else if obj
        res.json obj
      else
        next()

exports.update = (req, res, next) ->
  Page.findById req.params.id, (err, page) ->
    if err
      next err
    else
      delete req.body._id if req.body._id
      page = require("underscore").extend page, req.body

    page.save (err, obj) ->
      if err
        next err
      else if obj
        res.json obj
      else
        next()

exports.create = (req, res, next) ->
  (new Page req.body).save (err, obj) ->
    if err
      next err
    else if obj
      res.json obj
    else
      next()
