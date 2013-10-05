#= require '../namespace'

class window.FoodTruck.Code.HiQueryBar extends Backbone.Marionette.ItemView
  templateShow: 'query/header/show.jade'
  templateEdit: 'query/header/edit.jade'
  locals: -> { craftResults:ui.data.craftResults }

  alert:(ev) ->
    alert "clik #{@editMode()}"
    @toggleEditMode()

  events:
    'click': 'alert'
    'focus   input':   'hiStartEditing'
    'blur    input':   'hiStopEditing'
    'keydown input':   'hiStopEditingOnReturnKey'

  initialize: (attributes)=>
    super attributes
    @model = FoodTruck.models.location
    @$input = @$el.find('input')
    console.log 'init', attributes,  @$input.val()

  contentIsValid: => 0 isnt @$input.val().trim().length

  startEditing: ()=>
    @$input.addClass 'editing'

  stopEditing: ()=>
    @$input.removeClass 'editing'
    if @contentIsValid()
      @model.set 'place', @$input.val()
    else
      @$input.val(@model.get 'place')
    window.location.search = "?place=#{@model.get('place')}"
    # @model.fetch data: place: @model.get('place')

  hiStartEditing: (event)=>
    @startEditing()

  hiStopEditing: (event)=>
    @stopEditing()

  hiStopEditingOnReturnKey: (event)=>
    @stopEditing() if 13 is event.keyCode