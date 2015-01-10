environment = "development" unless process.env.NODE_ENV
config      = {}

try
  config = require "./#{environment}.local"

catch e
  config = require "./#{environment}"

config.database.connect = () ->
  config.database.handle = require("mongoose").connect config.database.uri, config.database.options
  config.database.handle

module.exports = config
