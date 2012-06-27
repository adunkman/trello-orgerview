express = require "express"
OAuth = (require "oauth").OAuth
rest = require "restler"
config = require "../config/app"
app = module.exports = express.createServer()

urls =
   request: "https://trello.com/1/OAuthGetRequestToken"
   access: "https://trello.com/1/OAuthGetAccessToken"

app.get "/login", (req, res, next) ->
   oauth = new OAuth(urls.request, urls.access, config.key, config.secret,
      "1.0", "http://#{req.headers.host}/login_callback", "PLAINTEXT")

   oauth.getOAuthRequestToken (error, token, token_secret, results) ->
      return next error if error

      req.session.oauth =
         token: token
         token_secret: token_secret

      res.redirect "https://trello.com/1/OAuthAuthorizeToken?oauth_token=#{token}&name=trello-orgerview"

app.get "/login_callback", (req, res, next) ->
   token = req.query.oauth_token
   secret = req.session.oauth.token_secret
   verifier = req.query.oauth_verifier

   oauth = new OAuth(urls.request, urls.access, config.key, config.secret,
      "1.0", "http://#{req.headers.host}/login_callback", "PLAINTEXT")

   oauth.getOAuthAccessToken token, secret, verifier,
      (error, access_token, access_token_secret, results) ->
         return next error if error

         req.session.oauth.access_token = access_token
         req.session.oauth.access_token_secret = access_token_secret

         res.redirect "/"

app.get "/logout", (req, res, next) ->
   req.session.destroy (error) ->
      return next error if error
      res.redirect "/"

get = (url, callback) ->
   request = rest.get url
   request.on "fail", (data, response) -> callback data, null
   request.on "error", (error, response) -> callback error, null
   request.on "success", (data, response) -> callback null, data
















