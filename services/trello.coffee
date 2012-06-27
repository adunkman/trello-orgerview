Trello = require "node-trello"
config = require "../config/app"
trello = new Trello(config.key)

module.exports = (req, res, next) ->
   if req.session.oauth?
      trello.token = req.session.oauth.access_token

   trello.isLoggedIn = () ->
      trello.token?

   req.services or= {}
   req.services.trello = trello
   next()