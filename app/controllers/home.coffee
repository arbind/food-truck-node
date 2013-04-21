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
  crafts = CraftService.search { location }
  locals = { location_hash, crafts }
  res.expose locals, 'ui.data'
  res.render 'home/index', locals