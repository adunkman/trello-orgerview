express = require "express"
app = module.exports = express.createServer()

app.get "/", (req, res) ->
   if not req.services.trello.isLoggedIn() then res.render "info/about"
   else
      req.services.trello.get "/1/members/my/organizations", (error, orgs) ->
         return next error if error
         res.render "info/orgs", orgs: orgs