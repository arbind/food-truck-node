exports.logout = (request, response) ->
  delete request.user
  delete request.session.passport if request.session?.passport?
  response.redirect '/'

exports.twitter = 
  callback: (request, response) ->
    response.redirect '/'

# exports.sudo = 
#   callback: (request, response) ->
#     response.redirect '/sudo'