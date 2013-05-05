dbURL = process.env.USER_SERVICE_MONGO_URL || process.env.MONGO_URL || "localhost:27017/food_truck_me_development"

class UserService
  @db: ->
    @mongoDB ?= (require 'mongoskin').db "#{dbURL}?auto_reconnect", {safe:true}

  @dbUsers: ->
    @db().collection 'users'

  @dbSuperUsers: ->
    @db().collection 'sudo-users'

  @dbStreamers: ->
    @db().collection 'tweet-streamers'

  @findById: (id, callback)->
    cursor = UserService.dbUsers().findById id, callback
 
  @newUser: ()-> { count: 0, lastAt: undefined }

  @signIn: (accessToken, profile, callback)->
    console.log "Service signing in user: ", profile.username
    qUser = { 'profile.provider': profile.provider, 'profile.providerId': profile.providerId }
    UserService.dbUsers().findOne qUser, (err, loginUser) ->
      console.log "registering new loginUser: ", profile.username
      loginUser ?= UserService.newUser()
      loginUser.accessToken = accessToken
      loginUser.profile = profile
      loginUser.signIns.count = loginUser.signIns.count + 1
      loginUser.signIns.lastAt = new Date
      delete loginUser._id
      UserService.dbUsers().update qUser, { $set: loginUser }, { upsert: true }, (error, ok)->
        return callback err if error? or not ok
        UserService.dbUsers().findOne qUser, (err, user) ->
          console.log 'returning user', user
          user.perspectives ?= []
          callback error, user

module.exports = UserService
