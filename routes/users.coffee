Users    = require "../controllers/users"
router   = require("express").Router()

router.post   "/",    Users.create
router.get    "/",    Users.index
###
router.get    "/:id", Users.get
router.put    "/:id", Users.update
router.delete "/:id", Users.delete
###

module.exports = router
