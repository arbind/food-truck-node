class CraftQuery
  @db: ->
    dbURL = process.env.CRAFT_SERVICE_MONGO_URL || global.mongoURL || "localhost:27017/craft_service_development"
    @mongoDB ?= (require 'mongoskin').db dbURL, {safe:true}

  @dbCrafts: ->
    @db().collection 'crafts'

  constructor: ({@user, @device, userQuery})->
    @page  = userQuery.page ? 1
    @page  = parseInt @page
    @limit = userQuery.limit ? 20
    @limit = parseInt @limit
    @place = userQuery.place  || @user?.place
    @radius = userQuery.radius || 100
    @radius = parseInt @radius
    @sortOrder = userQuery.sortOrder || {}
    @q = userQuery.q  || userQuery.query || userQuery.term
    if userQuery?.lat?
      @geoCoordinates =
        lat: userQuery?.lat
        lng: userQuery?.lng
    @geoCoordinates ?= @device?.geoCoordinates
    @appQuery =
      {
        @q
        @page
        @limit
        @place
        @radius
        @sortOrder
        @geoCoordinates
      }
    @result =
      metadata: {}


  findLocalCrafts: (callback)=>
    @geoLocate (err, {lat, lng})=>
      @geoCoordinates = { lat, lng }
      @scope = @findQuery()
      @scope.count (err, total)=>
        @result.metadata.total = total
        @filter()
        @sort()
        @paginate()
        @execute callback

  findQuery: =>
      @radius = 100 if @radius < 1
      lnglat = [ @geoCoordinates.lng, @geoCoordinates.lat ]
      coordinates =
        "$nearSphere": lnglat
        "$maxDistance": @radius / 3959
      query = { coordinates }
      console.log 'query', query
      CraftQuery.dbCrafts().find(query)

  filter: =>
    @scope = @scope

  sort: =>
    @scope = @scope.sort(['rank'], -1)

  paginate: =>
    @page  ?= 1
    @limit ?= 20
    @page   = 1 if @page < 2
    @limit  = 1000 if @limit > 1000
    offset  = (@page-1) * @limit
    @scope  = @scope.skip(offset).limit(@limit)

  execute: (callback)=>
    @scope.toArray (err, crafts)=>
      @result.error = err if err?
      @result.crafts = crafts
      @result.metadata.count = crafts?.length
      @result.metadata.appQuery = @appQuery
      callback err, @result

  geoLocate: (callback) =>
    if @geoCoordinates
      locate = (ignorePlace, callback)-> callback null, @geoCoordinates # echo
    else # if @place?
      locate ?= GeocodeService.geoCoordinates
    locate @place, callback

module.exports = CraftQuery

###
Calculating the radius for $nearSphear:
http://stackoverflow.com/questions/7837731/units-to-use-for-maxdistance-and-mongodb
---
$near assumes an idealized model of a flat earth,
meaning that an arcdegree of latitude (y) and longitude (x)
represent the same distance everywhere.
So you have to convert the radius by 111(in km) or 69(in miles) to get the result.

But $nearSphere you need to convert the radius by (6371 km or 3959 miles) to get it work...
you can read more about here: http://docs.mongodb.org/manual/core/geospatial-indexes/#GeospatialIndexing-TheEarthisRoundbutMapsareFlat
###
