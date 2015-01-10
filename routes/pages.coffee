Pages    = require "../controllers/pages"
router   = require("express").Router()

router.post   "/",    Pages.create
router.get    "/",    Pages.index
router.get    "/:id", Pages.get
router.put    "/:id", Pages.update
router.delete "/:id", Pages.delete

module.exports = router
