###
# getTemplate
#   Return a pre-compiled jade template
#   Assume jade templates to be available in jade.templates namespace
#   That is the default when using npm jade-browser
###
Backbone.Marionette.View::getTemplate =  ->
  templatePath = Marionette.getOption(@, "template");
  jade.templates[templatePath]

Backbone.Marionette.ItemView::serializeData = ->
  @locals()

Backbone.Marionette.ItemView::locals = ->
  item: @model?.attributes
