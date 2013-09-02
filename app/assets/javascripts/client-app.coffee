#= require './namespace'
#= require './models/index'
#= require './services/index'
#= require './hi/index'

class FoodTruck.Code.ClientApp
  views: 
    '#query-bar .location': (el)->
      new FoodTruck.Code.HiQueryBarLocation {el}

  constructor: ->
    FoodTruck.models.location = new Backbone.Model window.ui.data?.location_hash
    # @connectSocket()
    @bindViews()

  bindViews: => materializeView el for el, materializeView of @views when $(el).exists()

  connectSocket: =>
    return unless ui.socket?.channels?
    socket = io.connect()
    socket.on 'connect', ->
      console.log 'socket connected'

$ ->
  FoodTruck.app = new FoodTruck.Code.ClientApp