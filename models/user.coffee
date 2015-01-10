mongoose = require "mongoose"
Schema   = mongoose.Schema
crypto   = require "crypto"


# schema

userSchema = new Schema(
  name: String

  email:
    type: String
    unique: true
    required: true
    pattern: /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/

  secret:
    type: String

  salt:
    type: String
)


# virtuals

userSchema.virtual("password").set((password) ->
  @_password = password
  @salt = @makeSalt()
  @secret = @encryptPassword(password)
).get ->
  @_password

userSchema.virtual("user_info").get ->
  _id: @_id
  name: @name
  email: @email


# validations

validatePresenceOf = (value) ->
  value and value.length


# validate password virtual
userSchema.pre "save", (next) ->
  return next() unless @isNew
  unless validatePresenceOf(@password)
    next new Error("Invalid password")
  else
    next()


# methods
userSchema.methods =

  # authenticate
  authenticate: (plainText) ->
    @encryptPassword(plainText) is @secret


  # make salt
  makeSalt: ->
    crypto.randomBytes(16).toString "base64"


  # encrypt password
  encryptPassword: (password) ->
    return ""  if not password or not @salt
    salt = new Buffer(@salt, "base64")
    crypto.pbkdf2Sync(password, salt, 10000, 64).toString "base64"

module.exports = mongoose.model "User", userSchema
