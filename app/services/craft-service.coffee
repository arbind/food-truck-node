dbURL = process.env.CRAFT_SERVICE_MONGO_URL || "localhost:27017/craft_service_development"

class CraftService
  @db: ->
    @mongoDB ?= (require 'mongoskin').db dbURL

  @crafts: ->
    @db().collection 'crafts'

  @search: ({query, lat, lng, location, radius, page, limit}, callback)->
    radius ?= 100
    # if location? and not lat? and not Lng?
    #   { lat, lng } = GeoService.geoCoordinates location
    geoCoordinates = [ lat, lng ]
    q =
      coordinates: 
        "$nearSphere": geoCoordinates
        "$maxDistance": radius
    cursor = @crafts().find(q)
    cursor.count (err, total)-> 
      page ?= 1; page = 1 if page < 2
      limit ?= 20; limit = 100 if limit > 100
      offset = (page-1) * limit

      cursor.limit(limit).skip(offset).sort([['rank', 'desc']]).toArray (err, crafts)->
        count = crafts.length
        twitter_atts = ['name', 'description', 'profile_image_url', 'profile_background_color','profile_background_image_url','profile_background_tile']
        for craft in crafts
          for att in twitter_atts
            craft[att] = craft.twitter_craft?[att]
        duration = 0
        results =
          stats: { total, count, duration }
          query: { page, limit, query, lat, lng, location }
          crafts: crafts
        console.log results
        callback err, crafts

module.exports = CraftService