async = require 'async'

WebCraftYelpService = require 'web-craft-yelp-service'
yelpOAuth =
  wsid: process.env.YELP_WSID
  consumer_key: process.env.YELP_CONSUMER_KEY
  consumer_secret: process.env.YELP_CONSUMER_SECRET
  token: process.env.YELP_TOKEN
  token_secret: process.env.YELP_TOKEN_SECERT

# setup for caching with redis (session caching conforms to Yelp API developer's agreement)
cacheConfig =
  url: process.env.WEB_CRAFT_YELP_REDIS_URL || process.env.REDISTOGO_URL || 'redis://127.0.0.1:6379'
  dbNumber: process.env.WEB_CRAFT_YELP_REDIS_DB_NUMBER || 1
  prefix: 'wy.'
  bizTTL: 5 # 5*60*60     # 5hrs = 5*60s*60m
  sessionTTL: 5 #1*60*60  # 1hr  = 1*60s*60m

adaptBiz = (biz)-> 
  return biz unless biz?
  web_craft_id: biz.id # do this automatically in the service
  name: biz.name
  display_phone: biz.display_phone
  url: biz.url
  rating: biz.rating
  review_count: biz.review_count
  reviews: biz.reviews

serviceSettings =
  debug: false
  resultsPerPage: 20
  adaptBiz: adaptBiz
  cacheConfig: cacheConfig

webCraftYelpService = WebCraftYelpService.configure yelpOAuth, serviceSettings, (err, service)->
  console.log 'WebCraft Yelp Service Connected'

class HaloHaloService
  @localSearch: (mumbo_jumbo, searchCallback)->
    crafts = CraftService.localSearch mumbo_jumbo, (err, crafts)->
      if err? then callback err; return

      fetchChildWebCrafts = (craft, webCraftCallback)->
        childWebCrafts = 
          fetchYelpCraft: (yelpCallback)->
            webCraftYelpService.biz craft.yelp_craft.web_craft_id, yelpCallback

          fetchTwitterCraft: (twitterCallback)->
            craft.twitter_craft.timeline = TweetStreamService.timeline craft.twitter_craft.web_craft_id
            twitterCallback null, craft.twitter_craft

        async.parallel childWebCrafts, (err, webCrafts)->
          if err? then webCraftCallback err; return
          craft.yelp_craft = webCrafts.fetchYelpCraft
          craft.twitter_craft = webCrafts.fetchTwitterCraft
          webCraftCallback(err, craft)

      async.map crafts, fetchChildWebCrafts, searchCallback

module.exports = HaloHaloService
