path = require 'path'

express = require "express"
app = express()

COOKIE_SECRET = "secret_cookie_word"
SESSION_SECRET = "secret_session_word"
VIEWS_DIR = path.resolve __dirname, "../views"

# Development config
app.configure "development", ->
  app.use '/', express.static path.resolve __dirname, "../client"

# Production config
app.configure "production", ->
  app.use express.compress()
  app.use express.static path.resolve __dirname, "../dist"

app.configure ->
  renderer = require("ect") {
    cache: true
    watch: true
    root: VIEWS_DIR
  }
  app.engine ".ect", renderer.render

  app.use express.logger()
  app.use express.bodyParser()
  app.use express.cookieParser COOKIE_SECRET
  app.use express.session secret: SESSION_SECRET
  app.use app.router

require("./router") app
require("./socket") app

console.log "Go to http://localhost:3000 [" + process.env.NODE_ENV + " mode]"
app.listen 3000






