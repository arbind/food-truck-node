dbURL = process.env.CRAFT_SERVICE_MONGO_URL || "localhost:27017/craft_service"

class CraftService
  @db: ->
    @mongoDB ?= (require 'mongoskin').db dbURL

  @search: ({query, location, offset, limit})->
    # Mock up some crafts yo
    crafts = require '../../spec/server/fixtures/food-trucks'
    twitter_atts = ['name', 'description', 'profile_image_url', 'profile_background_color','profile_background_image_url','profile_background_tile',]
    for craft in crafts
      for att in twitter_atts
        craft[att] = craft.twitter_craft?[att]
    crafts

module.exports = CraftService