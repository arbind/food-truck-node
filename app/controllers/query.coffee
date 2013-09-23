params = (request)->
  _.extend (_.extend {}, request.query), request.params

adapt = (craftResults)->
  return craftResults.crafts = [] unless craftResults
  adaptedCrafts = (new CraftAdapter craft for craft in craftResults.crafts)
  craftResults.crafts = adaptedCrafts

findLocalCrafts = (context, callback)->
  craftQuery = new CraftQuery context
  craftQuery.findLocalCrafts (err, craftResults)->
    return callback err, [] if err?
    callback null, (adapt craftResults)

renderSearchResults = (format, request, response, userQuery)->
  user    = request.user
  device  = request.device
  context = { user, device, userQuery }
  findLocalCrafts context, (err, craftResults)->
    if err?
      console.log "!! ERROR: #{err}"
      craftResults = { crafts: [] } unless craftResults?
    clientData = { user, craftResults }
    if 'json' is format
      response.render clientData.toJSON()
    else
      response.expose clientData, 'ui.data'
      response.render 'query/index', clientData

renderHTMLSearchResults = (request, response, userQuery)->
  renderSearchResults 'html', request, response, userQuery

renderJSONSearchResults = (request, response, userQuery)->
  renderSearchResults 'json', request, response, userQuery

exports.index = (request, response) ->
  userQuery = params request
  userQuery = _.omit userQuery, ['page','limit'] # no scrolling allowed on index page
  renderHTMLSearchResults request, response, userQuery

exports.scroll = (request, response) ->
  userQuery = params requests
  renderJSONSearchResults request, response, userQuery