# configure an express app: code structure and environment (test, development, production)

global.appName = 'FoodTruck' # appName follows variable naming conventions (no spaces, etc) 

global.node_env = process.env.NODE_ENV || global.localEnvironment || 'test'
console.log "#{appName} running in  #{node_env} environment"

path          = (require 'path')
express       = (require 'express')
expose        = (require 'express-expose')
connectAssets = (require 'connect-assets')

passport      = (require 'passport')
TwitterStrategy = require('passport-twitter').Strategy

# export the app, and make it available globally
module.exports = global.app = express()

app.expose { } # ensure expose javascript is available

app.use (request, response, next)->  # redirect to www if nake domain is requested
  if 0 is request.subdomains.length
    [host, port] = request.headers.host.split ':'
    port ?= 80
    wwwURL = "#{request.protocol}://www.#{host}:#{port}"
    console.log 'issueing redirect from: ', request.headers.host, ' to ', wwwURL
    response.redirect wwwURL
  else
    next()

rootDir = (path.normalize __dirname + '/..')

sessionStore = new express.session.MemoryStore;

assetsPipeline = connectAssets src: 'app/assets'
css.root = 'stylesheets'
js.root = 'javascripts'

passport.serializeUser (user, done)-> done null, user._id
passport.deserializeUser (id, done)-> UserService.findById id, done

twitterConsumer = 
  consumerKey: process.env.TWITTER_CONSUMER_KEY
  consumerSecret: process.env.TWITTER_CONSUMER_SECRET
  callbackURL: process.env.TWITTER_CALLBACK_URL || "http://127.0.0.1:3000/auth/twitter/callback"

twitterSudoConsumer = 
  consumerKey: process.env.TWITTER_CONSUMER_KEY
  consumerSecret: process.env.TWITTER_CONSUMER_SECRET
  callbackURL: process.env.TWITTER_SUDO_CALLBACK_URL || "http://127.0.0.1:3000/auth/sudo/callback"

# twitterStreamerConsumer = 
#   consumerKey: process.env.TWITTER_CONSUMER_KEY
#   consumerSecret: process.env.TWITTER_CONSUMER_SECRET
#   callbackURL: process.env.TWITTER_STREAMER_CALLBACK_URL || "http://127.0.0.1:3000/auth/streamer/callback"

presenceFromTwitter = (profile)->
  {
    provider: 'twitter'
    providerId: "#{profile.id}"
    username: profile.username
    avatar: profile._json.profile_image_url
    followersCount: profile._json.followers_count
    friendsCount: profile._json.friends_count
    statusesCount: profile._json.statuses_count
    # name: profile.displayName
    # displayLocation: profile.location
    # timeZone: profile._json.time_zone
    # providerAccountCreatedAt: profile._json.created_at
  }

twitterSignIn = (token, tokenSecret, profile, done)->
  socialPresence = presenceFromTwitter(profile)
  console.log 'twitter sign in: ', socialPresence
  accessToken = { token, tokenSecret }
  UserService.signIn accessToken, socialPresence, done

# sudoSignIn = (token, tokenSecret, profile, done)->
#   socialPresence = presenceFromTwitter(profile)
#   console.log 'sudo sign in: ', socialPresence
#   accessToken = { token, tokenSecret }
#   UserService.signInForSudo accessToken, socialPresence, (err, sudo)->
#     consol.log "sudo Signed in: ", sudo
#     done err, sudo

# streamerSignIn = (token, tokenSecret, profile, done)->
#   socialPresence = presenceFromTwitter(profile)
#   console.log 'streamer sign in: ', socialPresence
#   accessToken = { token, tokenSecret }
#   UserService.signInForStreamer accessToken, socialPresence, (err, streamer)->
#     consol.log "streamer signed in: ", streamer
#     done err, streamer

twitterStrategy =  new TwitterStrategy twitterConsumer, twitterSignIn

# sudoStrategy =  new TwitterStrategy twitterSudoConsumer, sudoSignIn
# sudoStrategy.name = 'sudo'

# tweetStreamerStrategy =  new TwitterStrategy twitterStreamerConsumer, tweetStreamerSignIn
# tweetStreamerStrategy.name = 'tweet-streamer'

passport.use twitterStrategy
# passport.use sudoStrategy
# passport.use tweetStreamerStrategy

app.configure ->
  app.set 'port', process.env.PORT || process.env.VMC_APP_PORT || 8888
  app.set 'views', (rootDir + '/app/views')
  app.set 'view engine', 'jade'
  app.use express.cookieParser(process.env.COOKIE_SECRET)
  app.use express.session({ key: 'sid', secret: (process.env.SESSION_SECRET || 'secret-session'), store: sessionStore })
  app.use passport.initialize()
  app.use passport.session()
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(rootDir, 'public'))
  app.use assetsPipeline

app.configure 'production', ->
  app.use express.errorHandler()
app.configure 'development', ->
  app.use (express.errorHandler dumpExceptions: true, showStack: true )

fs = (require 'fs')

# application paths
global.rootPath = {}
rootDir = process.cwd()
rootPath.path =         (rootDir + '/')
rootPath.db =           (rootPath.path + 'db/')
rootPath.lib =          (rootPath.path + 'lib/')
rootPath.config =       (rootPath.path + 'config/')
rootPath.public =       (rootPath.path + 'public/')
rootPath.extentions =   (rootPath.lib + 'extentions/')

rootPath.app =          (rootPath.path + 'app/')
rootPath.utils =        (rootPath.app + 'utils/')
rootPath.assets =       (rootPath.app + 'assets/')
rootPath.models =       (rootPath.app + 'models/')
rootPath.controllers =  (rootPath.app + 'controllers/')
rootPath.services =     (rootPath.app + 'services/')

global.requireModuleInFile = (path, filename, config={})->
  globalize = if config.globalize? then config.globalize else true
  filePath = path+filename
  try
    if globalize and String.prototype.toClassName
      className = filename.toClassName()
      clazz = require filePath    # if anything is exported, assume that it is a Class
      global[className] = clazz   # make the class available globally
    else
      require filePath
  catch exception
    console.log ""
    console.log "!! could not load #{filename} from #{path}"
    throw exception

global.requireModulesInDirectory = (path, config={})->
  globalize = if config.globalize? then config.globalize else true
  (requireModuleInFile path, f, globalize) for f in fs.readdirSync(path)

# load some usefull stuff
requireModulesInDirectory rootPath.extentions, globalize: false
requireModulesInDirectory rootPath.utils
# global.Util = (require rootPath.utils + 'util')
# global.puts = (require rootPath.utils + 'puts')
# global.log  = (require rootPath.utils + 'log')

# set application configurations
global.redisURL = null # runtime environment would override this, if using redis
global.redisDBNumber = 99999 # runtime environment would also override this to one of the DB numbers below:
global.redisTestDB = 2
global.redisDevelopmentDB = 1
global.redisProductionDB = 0

global.mongoURL = null

# load runtime environment
require "./environments/#{node_env}"

# connect to mondoDB
if mongoURL
  global.mongoDB = (require 'mongoskin').db mongoURL
  # +++ create database if it does not exists?

# connect to redis
if redisURL
  global.redis = require('redis-url').connect(redisURL)
  redis.on 'connect', =>
    redis.send_anyways = true
    console.log "redis: connection established"
    redis.select redisDBNumber, (err, val) => 
      redis.send_anyways = false
      redis.selectedDB = redisDBNumber
      console.log "redis: selected DB ##{redisDBNumber} for #{env}"
      redis.emit 'db-select', redisDBNumber
      unless debug
        redis.keys '*', (err, keys)->
          console.log "redis: #{keys.length} keys present in DB ##{redisDBNumber} "

# load classes
require rootPath.models
require rootPath.services

# Load app routes
require './routes'

