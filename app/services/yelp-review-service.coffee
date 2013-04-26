class YelpReviewService
  @reviews: (bizId, callback)->
    reviews = 
      for r in [0..3]
        yelp_id: r
        user:
          id: "user#{r}"
          image_url: 'http://placekitten.com/100/100'
          name: "name#{r}"
        rating_image_url: 'http://placekitten.com/80/20'
        excerpt: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'
        time_created: 'a day ago'
    # callback null reviews
    return reviews

module.exports = YelpReviewService
