#= require './namespace'
#= require './models/index'
#= require './services/index'
#= require './hi/index'

class FoodTruck.Code.ClientApp
  views:
    '#query-bar': (el)->
      new FoodTruck.Code.HiQueryBar {el}

  constructor: ->
    FoodTruck.models.location = new Backbone.Model window.ui.data?.location
    # @connectSocket()
    @bindViews()

  bindViews: => materializeView el for el, materializeView of @views when $(el).exists()

  connectSocket: =>
    return unless ui.socket?.channels?
    socket = io.connect()
    socket.on 'connect', ->
      console.log 'socket connected'


window.BMClientApp = new Backbone.Marionette.Application()

FoodTruck.Code.Model.Craft = Backbone.Model.extend {}
FoodTruck.Code.Model.CraftList = Backbone.Collection.extend model:FoodTruck.Code.Model.Craft

FoodTruck.Code.View.Craft = Backbone.Marionette.ItemView.extend {
  template: 'craft/craft.jade'
  locals: -> craft: @model?.attributes

  events:
    'click .button': 'alert'

  alert:(ev) ->
    alert 'clik'
    BMClientApp.scroll()
}

FoodTruck.Code.ViewCraft0 = Backbone.Marionette.ItemView.extend {
  template: '#view-craft-0'
}

FoodTruck.Code.View.CraftList = Backbone.Marionette.CollectionView.extend {
  itemView:  FoodTruck.Code.View.Craft
  emptyView: FoodTruck.Code.View.Craft0
}

BMClientApp.addRegions {
  craftListScrollEl: '#craft-list-scroll'  # add crafts here for infinite scroll
}

BMClientApp.scroll = ->
  alert 'scrolling'
  craftListData = ui.data.craftResults.crafts
  console.log craftListData
  BMClientApp.craftListScroll.add craftListData

BMClientApp.addInitializer  ->
  # Bind to already rendered views
  craftListData = ui.data.craftResults.crafts.splice(0,10)
  BMClientApp.craftList = new FoodTruck.Code.Model.CraftList []
  BMClientApp.craftListView = new FoodTruck.Code.View.CraftList collection: BMClientApp.craftList
  console.log craftListData
  for craft in craftListData
    el = craft.el
    model = new FoodTruck.Code.Model.Craft craft
    view = new FoodTruck.Code.View.Craft { el, model }
    # where do we put this view?
    # can we combine this collection with the scroll area collection?

BMClientApp.addInitializer  ->
  # infinite scroll area for
  BMClientApp.craftListScroll = new FoodTruck.Code.Model.CraftList []
  BMClientApp.craftListScrollView = new FoodTruck.Code.View.CraftList collection: BMClientApp.craftListScroll
  BMClientApp.craftListScrollEl.show BMClientApp.craftListScrollView

$ ->
  FoodTruck.app = new FoodTruck.Code.ClientApp

  BMClientApp.start()
