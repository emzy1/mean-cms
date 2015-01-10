path   = require "path"
config = require "./config"
handle = config.database.connect()

# setup server
app = require('express')()
app.use require("body-parser").json()

# jade
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

require("./routes/")(app)

server = require('http').createServer(app)

server.listen config.port, () ->
  console.log "Express server listening on %d, in %s mode", config.port, app.get("env")

module.exports = app
