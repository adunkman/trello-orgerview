express = require "express"
port = process.env.PORT || 3000
app = express.createServer()

# Settings
app.set "view engine", "jade"
app.set "view options", layout: false

app.configure "development", () ->
   app.use express.logger "dev"
   app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure "production", () ->
   app.use express.errorHandler()

# Middleware
app.use require("connect-assets")()
app.use express.cookieParser()
app.use express.session secret: "b36ead77-d81b-4291-ac1f-1a126957e7bf"
app.use express.static __dirname + "/../public"

# Services
app.use require "../services/trello"

# Controllers
app.use require "./authentication"
app.use require "./info"

# Listen
app.listen port
console.log "trello-orgerview booted, listening on #{port}."