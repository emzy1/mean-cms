mongoose = require "mongoose"

module.exports = mongoose.model "Page", new mongoose.Schema
  meta:
    title:
      type: String
    description:
      type: String

  path:
    type: String
    unique: true

  content:
    type: String
