class CraftAdapter
  constructor: (craft)->
    console.log craft
    # @[attr] = val for attr, val of craft
    @id = "#{craft._id}"
    @elId = "craft-#{@id}"
    @el = "##{@elId}"
    @address = craft.address
    if 2 is craft.coordinates?.length
      @lng = craft.coordinates[0]
      @lat = craft.coordinates[1]
    @name = (craft.twitter_craft?.name) || (craft.yelp_craft?.name) || (craft.facebook_craft?.name)
    @avatar = craft.twitter_craft?.profile_image_url_https
    @bgColor = craft.twitter_craft?.profile_background_color || '#FFF'
    @bgRepeat =  craft.twitter_craft?.profile_background_tile ? 'repeat' : 'no'
    @twitterId = craft.twitter_craft?.web_craft_id
    @twitterScreenName = craft.twitter_craft?.username
    @twitterURL = craft.twitter_craft?.href
    @twitter = craft.twitter_craft?.web_craft_id
    @yelpId = craft.yelp_craft?.web_craft_id
    @yelpURL = craft.yelp_craft?.href
    @facebookId = craft.facebook_craft?.web_craft_id
    @facebookURL = craft.facebook_craft?.href
    @facebookLikes = craft.facebook_craft?.likes
    @websiteURL = craft.website_craft?.website

module.exports = CraftAdapter
