exports.index = (request, response) ->
  user = request.user
  location = request.query.location ? request.params.location ? 'Austin, TX'

  location_hash = 
    nickname: location
    city: location
    state: 'CA'
    coordinates:
      lat: 1
      lng: 2

  mumbo_jumbo =
    sessionId: request.sessionID
    place: location
    # xlat: -97.7430608
    # xlng: 30.267153
    page: 1
    limit: 20
    query: null
    radius: 100

  crafts = HaloHaloService.localSearch mumbo_jumbo, (err, crafts)->
    clientData = { location_hash, crafts }
    response.expose clientData, 'ui.data'
    locals = { user, location_hash, crafts, request}
    response.render 'home/index', locals