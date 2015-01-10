module.exports = (app) ->
  app.use "/api/users",    require "./users"
  app.use "/api/pages",    require "./pages"
  app.use "/api/sessions", require "./sessions"

  app.get /^\/views\/(.+)/, (req, res, next) ->
    res.render req.params[0], (err, html) ->
      if err
        next err
      else
        res.send html

  app.get "/admin/*", (req, res, next) ->
    res.render "templates/admin", (err, html) ->
      if err
        next err
      else
        res.send html

  app.use "/vendor", require("express").static(require("path").join(__dirname, "../bower_components"))

  app.get "/:path", require("../controllers/pages").get

  app.use require("connect-assets")
    paths: [
      "public/stylesheets"
      "public/javascripts"
    ]
