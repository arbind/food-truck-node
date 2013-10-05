#= require '../namespace'

class window.FoodTruck.Code.HiQueryBarLocation extends Backbone.View
  events:
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