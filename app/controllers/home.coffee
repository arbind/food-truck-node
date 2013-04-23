exports.index = (req, res) ->
  location = req.query.location ? req.params.location ? 'Santa Monica'
  console.log 'query', req.query
  console.log 'params', req.params

  location_hash = 
    nickname: location
    city: location
    state: 'CA'
    coordinates:
      lat: 1
      lng: 2

  options =
    place: 'Austin, tx' 
    xlat: -97.7430608
    xlng: 30.267153
    page: 1
    limit: 2
    query: null
    radius: 100

  crafts = CraftService.localSearch options, (err, crafts)->
    locals = { location_hash, crafts }
    res.expose locals, 'ui.data'
    res.render 'home/index', locals