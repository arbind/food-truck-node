controllers = require rootPath.controllers

# create javascript namespace for ui.adapters (using express-expose)
# app.all '*', (req, res, next) -> res.expose({}, 'ui.adapters'); next()

app.get '/', controllers.home.index
app.get '/:location', controllers.home.index
