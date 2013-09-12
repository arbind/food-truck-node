exports.index = (request, response) ->
  user = request.user
  location = request.query.location ? request.params.location ? 'Austin, TX'

  location_hash =
    nickname: location

  mumbo_jumbo =
    sessionId: request.sessionID
    place: location
    # lat: -97.7430608
    # lng: 30.267153
    page: 1
    limit: 20
    query: null
    radius: 100

  HaloHaloService.localSearch mumbo_jumbo, (err, craft_results)->
    crafts = (c for c in craft_results when c)
    clientData = { location_hash, crafts }
    response.expose clientData, 'ui.data'
    locals = { user, location_hash, crafts, request}
    response.render 'home/index', locals