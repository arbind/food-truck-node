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



# class WebCraftTwitterService

#   configure: ({ @adaptTwitterCraft, @resultsPerPage, @debug }, callback)->
#     @resultsPerPage ?= 20
#     @debug ?=false
#     @adaptTwitterCraft ?= (twitterCraft) -> twitterCraft

#     callback?(null, @)
#     @

#   # Fetch a twitterCraft by its twitterId
#   fetch: (twitterId, callback)=>
#     {
#         t:
#           for t in [0..3]
#             id: t
#             name: "Name#{t} tweeter"
#             screen_name: "tweeter#{t}"
#             profile_image_url: 'http://placekitten.com/100/100'
#             text: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'
#             created_at: 'a day ago'
#             in_reply_to_status_id: t
#     }
#   # need to create a socket version of this to return each biz 1 at a time (asynchrounously) as they are retrieved
#   fetchList: (twitterIdList, callback)=>
#     list = []
#     for twitterId in twitterIdList
#       @fetch twitterId, (err, twitterCraft)=>
#         list.push twitterCraft
#         callback(null, list) if list.length is twitterIdList.length

