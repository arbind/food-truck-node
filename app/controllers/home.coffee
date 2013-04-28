exports.index = (request, response) ->
  location = request.query.location ? request.params.location ? 'Santa Monica'

  location_hash = 
    nickname: location
    city: location
    state: 'CA'
    coordinates:
      lat: 1
      lng: 2

  mumbo_jumbo =
    sessionId: request.sessionID
    place: 'Austin, tx' 
    xlat: -97.7430608
    xlng: 30.267153
    page: 1
    limit: 2
    query: null
    radius: 100

  crafts = HaloHaloService.localSearch mumbo_jumbo, (err, crafts)->
    locals = { location_hash, crafts }
    response.expose locals, 'ui.data'
    locals.request = request
    response.render 'home/index', locals