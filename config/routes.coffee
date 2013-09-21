passport = require 'passport'
controllers = require rootPath.controllers

showRequest = (msg, property)->
  property ?= 'session'
  (request, response, next)->
    console.log '\n\n', msg, '\n', 'request:', request[property]
    next()

sudoProtected = (request, response, next)->
  return next() if UserService.isSudoUser request.user
  controllers.oauth.util.clearUser request
  response.redirect('/oauth/sudo')

# user logout
app.get '/logout',
  controllers.oauth.logout

# twitter oauth login
app.get '/oauth/twitter',
  passport.authenticate 'twitter'

app.get '/oauth/twitter/callback',
  passport.authenticate('twitter', { failureRedirect: '/logout' }),
  controllers.oauth.twitter.callback

# sudo oauth login via twitter
app.get '/oauth/sudo',
  passport.authenticate 'sudo'

app.get '/oauth/sudo/callback',
  passport.authenticate('sudo', { failureRedirect: '/logout' }),
  controllers.oauth.sudo.callback

# sudo protected pages
app.get '/sudo',
  sudoProtected,
  controllers.sudo.dashboard

# user protected pages
# +++ favorites
# +++ notification preferences


# Style Kit
app.get  '/style',
  controllers.style.index

# public pages
app.get  '/',
  controllers.query.index

app.get '/:location',
  controllers.query.index
