class TweetStreamService
  @timeline: (screenName, callback)->
    tweets = 
      for t in [0..3]
        id: t
        name: "Name#{t} tweeter"
        screen_name: "tweeter#{t}"
        profile_image_url: 'http://placekitten.com/100/100'
        text: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'
        created_at: 'a day ago'
        in_reply_to_status_id: t
    # callback null reviews
    return tweets

module.exports = TweetStreamService
