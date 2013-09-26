action = exports

action.index = (request, response) ->
  userQuery = params request
  userQuery = _.omit userQuery, ['page','limit'] # no scrolling allowed on index page
  executeQuery request, response, userQuery

action.scroll = (request, response) ->
  userQuery = params requests
  executeQuery request, response, userQuery, 'JSON'

params = (request)->
  _.extend (_.extend {}, request.query), request.params

renderQueryResultsInHTML = (response, clientData)->
  response.expose clientData, 'ui.data'
  response.render 'query/index', clientData

renderQueryResultsInJSON = (response, clientData)->
  response.render clientData.toJSON()

adapt = (craftResults)->
  return { crafts: [] } unless craftResults?.crafts?
  adaptedCrafts = (new CraftAdapter craft for craft in craftResults.crafts)
  craftResults.crafts = adaptedCrafts
  craftResults

findLocalCrafts = (context, callback)->
  craftQuery = new CraftQuery context
  craftQuery.findLocalCrafts (err, craftResults)->
    return callback err, null if err?
    callback null, (adapt craftResults)

executeQuery = (request, response, userQuery, format='html')->
  user    = request.user
  device  = request.device
  if Object.keys(userQuery).length is 0
    clientData = { user, craftResults: crafts: [] }
    renderQueryResultsInHTML response, clientData
  else
    context = { user, device, userQuery }
    findLocalCrafts context, (err, craftResults)->
      console.log "!! ERROR: #{err}" if err?

      craftResults = crafts: [] unless craftResults?.crafts?
      clientData = { user, craftResults }
      if 'json' is format.toLowerCase()
        renderQueryResultsInJSON response, clientData
      else
        renderQueryResultsInHTML response, clientData
