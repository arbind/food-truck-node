exports.util = 
  clearUser: (request) ->
    delete request.user
    delete request.session.passport if request.session?.passport?

exports.logout = (request, response) ->
  exports.util.clearUser request
  response.redirect '/'

exports.twitter = 
  callback: (request, response) ->
    response.redirect '/'

exports.sudo = 
  callback: (request, response) ->
    response.redirect '/sudo'


