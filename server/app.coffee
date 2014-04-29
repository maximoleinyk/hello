path = require 'path'

express = require "express"
app = express()

COOKIE_SECRET = "secret_cookie_word"
SESSION_SECRET = "secret_session_word"

app.configure "development", ->
  app.use '/', express.static path.resolve __dirname, "../client"
  app.set 'views', path.resolve __dirname, "../server/views"

app.configure "production", ->
  app.use '/', express.static path.resolve __dirname, "../dist/client"
  app.set 'views', path.resolve __dirname, "../dist/server"

app.configure ->
  app.engine ".ect", require("ect")().render
  app.use express.logger()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser COOKIE_SECRET
  app.use express.session secret: SESSION_SECRET
  app.use app.router

require("./router") app
require("./socket") app

console.log "Go to http://localhost:3000 [" + process.env.NODE_ENV + " mode]"
app.listen 3000






