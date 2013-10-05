###
# getTemplate
#   Return a pre-compiled jade template
#   Assume jade templates to be available in jade.templates namespace
#   That is the default when using npm jade-browser
###
Backbone.Marionette.View::getTemplate =  ->
  if @editMode()
    templateToUse = "templateEdit"
  else
    templateToUse = "templateShow"

  templatePath = Marionette.getOption @, templateToUse
  templatePath ?= Marionette.getOption @, "template"
  jade.templates[templatePath]

Backbone.Marionette.ItemView::serializeData = ->
  @locals()

Backbone.Marionette.ItemView::locals = ->
  item: @model?.attributes

Backbone.Marionette.View::editMode =  ->
  !!@options["editMode"]

Backbone.Marionette.View::setEditMode = (inEditMode)->
   @options["editMode"] = !!inEditMode
   @render()
   @$el?.addClass 'editing' if @editMode()
   @$el?.removeClass 'editing' unless @editMode()

Backbone.Marionette.View::editModeOn = ->
  @setEditMode true if !@editMode()

Backbone.Marionette.View::editModeOff = ->
  @setEditMode false if @editMode()

Backbone.Marionette.View::toggleEditMode =  ->
  @setEditMode !@editMode()
