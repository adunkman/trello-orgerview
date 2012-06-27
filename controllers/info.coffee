express = require "express"
app = module.exports = express.createServer()

app.get "/", (req, res) ->
   if req.services.trello.isLoggedIn() then res.render "info/orgs"
   else
      req.services.trello.get "/1/members/my/organizations", (error, data) ->
         console.error error
         console.log data
         res.render "info/about"