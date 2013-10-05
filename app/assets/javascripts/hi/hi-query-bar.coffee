#= require '../namespace'

class window.FoodTruck.Code.HiQueryBar extends Backbone.Marionette.ItemView
  templateShow: 'query/header/show.jade'
  templateEdit: 'query/header/edit.jade'
  locals: -> { location : @model?.attributes }

  events:
    'click': 'hiStartEditing'
    'blur    input':   'hiStopEditing'
    'keydown input':   'hiStopEditingOnReturnKey'

  initialize: (attributes)=>
    super attributes
    @model = FoodTruck.models.location
    @editModeOn() unless @place()

  place: (val)=>
    if val?
      @model.set 'place', val.trim()
    else
      @model.get 'place'

  sendUserQuery: =>
    window.location.search = "?place=#{@place()}"
    # @model.fetch data: place: @model.get('place')

  startEditing: ()=>
    @editModeOn()
    @$input = @$el.find('input')
    @$input.focus()

  stopEditing: ()=>
    if @userEntryChanged() and @userEntryIsValid()
      @place @$input.val()
      @sendUserQuery()
    else
      @$input.val @place()
      @editModeOff() if @place()

  userEntryIsValid: => 0 isnt @$input.val()?.trim()?.length
  userEntryChanged: => @place()?.trim() isnt @$input.val()?.trim()

  hiStartEditing: (event)=>
    @startEditing()

  hiStopEditing: (event)=>
    @stopEditing()

  hiStopEditingOnReturnKey: (event)=>
    @stopEditing() if 13 is event.keyCode