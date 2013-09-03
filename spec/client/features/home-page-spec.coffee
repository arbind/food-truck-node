app     = require (process.cwd() + '/config/application')
http    = (require 'http')
phantom = require 'phantom'

port = app.get 'port'
endpoint = "http://localhost:#{port}"

httpServer  = http.createServer app
httpServer.listen port, ->
  console.log "Express server listening on port #{port}"

urlForPath = (path) -> "#{endpoint}#{path}"

describe 'client', ->
  @timeout = -> 8000

  page = null
  headlessBrowser = null

  before (done) ->
    phantom.create (ph) =>
      headlessBrowser = ph
      headlessBrowser.createPage (webPage) =>
        page = webPage
        done()

  after (done) ->
    headlessBrowser.exit()
    done()

  describe 'GET /', ->
    before (done) ->
      url = urlForPath '/'
      page.open url, (status) =>
        (expect status).to.equal 'success'
        done()

    it 'has a page title', (done) ->
      page.evaluate (-> document.title), (result) =>
        (expect result).to.equal appName
        done()

    it 'has a query bar', (done) ->
      page.evaluate (-> $('#query-bar')), (elements) =>
        (expect elements.length).to.eq 1
        done()
