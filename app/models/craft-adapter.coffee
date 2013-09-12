class CraftAdapter
  constructor: (craft)->
    @[attr] = val for attr, val of craft

  @getter 'name', ->
    (@twitter_craft?.name) || (@yelp_craft?.name) || (@facebook_craft?.name)


  @getter 'avatar',   -> @twitter_craft?.profile_image_url_https

  @getter 'bgColor',   -> @twitter_craft?.profile_background_color || '#FFF'

  @getter 'bgImage',   ->
    if @twitter_craft?.profile_use_background_image.toLowerCase().indexOf 't' > -1
      @twitter_craft.profile_background_image_url_https
    else
      null

  @getter 'bgRepeat',   ->
    @twitter_craft?.profile_background_tile ? 'repeat' : 'no'

  @getter 'twitterId',   -> @twitter_craft?.web_craft_id
  @getter 'twitterScreenName', -> @twitter_craft?.username
  @getter 'twitterURL',  -> @twitter_craft?.href
  @getter 'twitter',     -> @twitter_craft?.web_craft_id

  @getter 'yelpId',      -> @yelp_craft?.web_craft_id
  @getter 'yelpURL',     -> @yelp_craft?.href

  @getter 'facebookId',  -> @facebook_craft?.web_craft_id
  @getter 'facebookURL', -> @facebook_craft?.href
  @getter 'facebookLikes', -> @facebook_craft?.likes

  @getter 'websiteURL',  -> @website_craft?.website

module.exports = CraftAdapter
