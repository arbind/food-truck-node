dbURL = process.env.USER_SERVICE_MONGO_URL || process.env.MONGO_URL || "localhost:27017/food_truck_me_development"

ERROR_NOT_AUTHORIZED = new Error "Not Authorized!"
SUDO_USER_TWITTER_IDS = [ '14956791' ]

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
 
  @newUser: ()-> { signIns: {count: 0, lastAt: undefined } }

  @isSudoUser: (user)-> 
    (user?.perspectives? and 'sudo' in user.perspectives) or user?.profile?.providerId in SUDO_USER_TWITTER_IDS

  @signIn: (accessToken, profile, callback)-> # auto-register user if necessary
    qUser = { 'profile.provider': profile.provider, 'profile.providerId': profile.providerId }
    UserService.dbUsers().findOne qUser, (err, loginUser) ->
      loginUser ?= UserService.newUser()
      loginUser.accessToken = accessToken
      loginUser.profile = profile
      loginUser.signIns.count = loginUser.signIns.count + 1
      loginUser.signIns.lastAt = new Date
      delete loginUser._id
      # update loginUser's profile (insert if necessary for auto-registration)
      UserService.dbUsers().update qUser, { $set: loginUser }, { upsert: true }, (error, ok)->
        return callback err if error? or not ok
        UserService.dbUsers().findOne qUser, (err, user) ->
          user.perspectives ?= []
          callback error, user

  @signInForSudo: (accessToken, profile, callback)-> # do not auto-register sudo user!
    qUser = { 'profile.provider': profile.provider, 'profile.providerId': profile.providerId }
    UserService.dbUsers().findOne qUser, (err, loginUser) ->
      unless UserService.isSudoUser loginUser
        console.log 'sudo sign in: ', ERROR_NOT_AUTHORIZED, "from #{loginUser?.profile?.provider} by #{loginUser?.profile?.username}"
        return callback()
      loginUser.accessToken = accessToken
      loginUser.profile = profile
      loginUser.signIns.count = loginUser.signIns.count + 1
      loginUser.signIns.lastAt = new Date
      _id = loginUser._id
      delete loginUser._id
      # update sudo loginUser's profile
      UserService.dbUsers().update { _id }, { $set: loginUser }, { upsert: false }, (error, ok)->
        return callback err if error? or not ok
        UserService.dbUsers().findOne qUser, (err, user) ->
          callback error, user

module.exports = UserService
