Trello = require "node-trello"
config = require "../config/app"

module.exports = (req, res, next) ->
   accessToken = req.session.oauth?.oauth_access_token
   trello = new Trello(config.key, accessToken)

   trello.isLoggedIn = () ->
      trello.token?

   req.services or= {}
   req.services.trello = trello
   next()