#= require '../namespace'
#= require '../models/location-bar'

# class window.FoodTruck.Code.HiLocationBar extends Backbone.View
#   events:
#     'focus   .city':   'hiCityStartEditing'
#     'blur    .city':   'hiCityStopEditing'
#     'input   .city':   'hiCityInputEntered'
#     'keydown .city':   'hiCityFilterTyping'

#   initialize: (attributes)=>
#     super attributes
#     console.log FoodTruck
#     @model = new FoodTruck.Code.LocationBar place: window.FoodTruck.models.location?.place

#     @$city = @$('.city')

#   cityContentIsValid: => 0 is @$city.children().length

#   stopEditingCity: ()=>
#     if @cityContentIsValid()
#       @model.set 'place', @$city.html()
#     else
#       @$city.html @model.get 'place'

#   hiCityStartEditing: (event)=>
#     @$city.addClass 'editing'

#   hiCityStopEditing: (event)=>
#     @stopEditingCity()
#     @$city.removeClass 'editing'
#     console.log 'fetching', @model.get('place')
#     @model.fetch data: place: @model.get('place')

#   hiCityInputEntered: (event)=> @stopEditingCity unless @cityContentIsValid()

#   hiCityFilterTyping: (event)=>
#     validKeyCodes =  # this doesn't seem to match ascii chars?
#     [
#       8
#       14
#       15
#       16
#       32
#       37
#       39
#       [45..58]...
#       [65..90]...
#       [97..122]...
#       127
#       190
#       222
#     ]
#     unless event.keyCode in validKeyCodes
#       event.preventDefault()
#       @$city.blur()
