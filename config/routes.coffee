passport = require 'passport'
controllers = require rootPath.controllers

showRequest = (msg, property)->
  property ?= 'session'
  (request, response, next)->
    console.log '\n\n', msg, '\n', 'request:', request[property]
    next()

# sudoProtected = (request, response, next)->
#   return next() if request.user?.perspectives? and 'sudo' in request.user.perspectives
#   response.redirect('/oauth/sudo')

# user logout
app.get '/logout', 
  controllers.oauth.logout

# twitter oauth login
app.get '/oauth/twitter',
  passport.authenticate 'twitter'

app.get '/oauth/twitter/callback', 
  passport.authenticate('twitter', { failureRedirect: '/' }),
  controllers.oauth.twitter.callback

# # sudo twitter oauth login
# app.get '/oauth/sudo',
#   showRequest('before oauth/sudo '),
#   passport.authenticate 'sudo'

# app.get '/oauth/sudo/callback', 
#   showRequest('before oauth/sudo/callback '),
#   passport.authenticate('sudo', { failureRedirect: '/' }),
#   controllers.oauth.sudo.callback

# # sudo protected pages
# app.get '/sudo',
#   showRequest('before sudo protection'),
#   sudoProtected,
#   showRequest('after sudo protection'),
#   controllers.sudo.dashboard

# user protected pages



# public pages
app.get  '/',
  controllers.home.index

app.get '/:location',
  controllers.home.index
