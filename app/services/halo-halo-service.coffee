class HaloHaloService
  @localSearch: (mumbo_jumbo, callback)->
    crafts = CraftService.localSearch mumbo_jumbo, (err, crafts)->
      if err? then callback err; return
      for craft in crafts
        craft.yelp_craft.reviews = YelpReviewService.reviews craft.yelp_craft.web_craft_id
        craft.twitter_craft.timeline = TweetStreamService.timeline craft.twitter_craft.web_craft_id
      callback null, crafts

module.exports = HaloHaloService
