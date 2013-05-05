dbURL = process.env.CRAFT_SERVICE_MONGO_URL || "localhost:27017/craft_service_development"

class CraftService
  @db: ->
    @mongoDB ?= (require 'mongoskin').db dbURL, {safe:true}

  @dbCrafts: ->
    @db().collection 'crafts'

  @localSearch: ({query, lat, lng, place, radius, page, limit}, callback)->
    if place? and not lat? and not Lng?
      lookupGeoCoordinates = GeocodeService.geoCoordinates
    else if not place? and lat? and Lng?
      lookupGeoCoordinates = (place, callback)-> callback null, { lat, lng } # echo back lat, lng

    lookupGeoCoordinates place, (err, {lat, lng})->
      geoCoordinates = [ lng, lat ]
    
      radius ?= 100 # in miles
      radius = 100 if radius < 0
      q =
        coordinates:
          "$nearSphere": geoCoordinates
          "$maxDistance": radius / 3959
      cursor = CraftService.dbCrafts().find(q)
      cursor.count (err, total)->
        page ?= 1; page = 1 if page < 2
        limit ?= 20; limit = 100 if limit > 100
        offset = (page-1) * limit

        cursor.limit(limit).skip(offset).sort([['rank', 'desc']]).toArray (err, crafts)->
          count = crafts?.length
          if crafts
            twitter_atts = ['name', 'description', 'profile_image_url', 'profile_background_color','profile_background_image_url','profile_background_tile']
            for craft in crafts
              for att in twitter_atts
                craft[att] = craft.twitter_craft?[att]
          duration = 0
          results =
            status: err ? 'ok'
            stats: { total, count, duration }
            query: { page, limit, query, lat, lng, place }
            crafts: crafts
          callback err, crafts

module.exports = CraftService

###
Calculating the radius for $nearSphear:
http://stackoverflow.com/questions/7837731/units-to-use-for-maxdistance-and-mongodb
---
$near assumes an idealized model of a flat earth, 
meaning that an arcdegree of latitude (y) and longitude (x) 
represent the same distance everywhere. 
So you have to convert the radius by 111(in km) or 69(in miles) to get the results.

But $nearSphere you need to convert the radius by (6371 km or 3959 miles) to get it work...
you can read more about here: http://docs.mongodb.org/manual/core/geospatial-indexes/#GeospatialIndexing-TheEarthisRoundbutMapsareFlat
###
