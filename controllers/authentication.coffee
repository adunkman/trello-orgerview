express = require "express"
OAuth = (require "node-trello").OAuth
config = require "../config/app"
app = module.exports = express.createServer()

app.get "/login", (req, res, next) ->
   oauth = adapterFor req.headers.host

   oauth.getRequestToken (error, bag) ->
      return next error if error
      req.session.oauth = bag
      res.redirect bag.redirect

app.get "/login_callback", (req, res, next) ->
   bag = merge req.session.oauth, req.query
   oauth = adapterFor req.headers.host

   oauth.getAccessToken bag, (error, bag) ->
      return next error if error
      req.session.oauth = bag
      res.redirect "/"

app.get "/logout", (req, res, next) ->
   req.session.destroy (error) ->
      return next error if error
      res.redirect "/"

adapterFor = (host) ->
   callbackUrl = "http://#{host}/login_callback"
   new OAuth(config.key, config.secret, callbackUrl, "trello-orgerview")

merge = (to, from) ->
   to[key] = value for key, value of from
   return to
