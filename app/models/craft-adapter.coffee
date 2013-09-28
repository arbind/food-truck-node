class CraftAdapter
  constructor: (craft)->
    @id = "#{craft._id}"
    @elId = "craft-#{@id}"
    @el = "##{@elId}"
    @address = craft.address
    if 2 is craft.coordinates?.length
      @lng = craft.coordinates[0]
      @lat = craft.coordinates[1]
    @name = (craft.twitter?.name) || (craft.yelp?.name) || (craft.facebook?.name)
    @avatar = craft.twitter?.profile_image_url_https
    @bgColor = craft.twitter?.profile_background_color || '#FFF'
    @bgRepeat =  craft.twitter?.profile_background_tile ? 'repeat' : 'no'
    @twitterId = craft.twitter?.web_craft_id
    @twitterScreenName = craft.twitter?.username
    @twitterURL = craft.twitter?.href
    @twitter = craft.twitter?.web_craft_id
    @yelpId = craft.yelp?.web_craft_id
    @yelpURL = craft.yelp?.href
    @facebookId = craft.facebook?.web_craft_id
    @facebookURL = craft.facebook?.href
    @facebookLikes = craft.facebook?.likes
    @websiteURL = craft.website?.website

module.exports = CraftAdapter
