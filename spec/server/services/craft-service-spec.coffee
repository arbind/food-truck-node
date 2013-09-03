require (process.cwd() + '/config/application')

describe 'Services', ->
  sandbox = null
  beforeEach (done) ->
    sandbox = sinon.sandbox.create()
    done()
  beforeEach (done) ->
    fakeResults = [chai.create('craft'), chai.create('craft'), chai.create('craft')]
    fakeLocalSearch= sandbox.stub(CraftService, 'localSearch')
    .yields null, fakeResults
    done()

    afterEach (done) ->
      sandbox.restore()
      done()

  it 'can test a service', (done) =>
    query = {query:'food', place: 'santa monica'}
    CraftService.localSearch query, (err, results)->
      (expect results.length).to.eq 3
      done()

  it 'can test another service', (done) =>
    query = {query:'food', place: 'santa monica'}
    CraftService.localSearch query, (err, results)->
      (expect results.length).to.eq 3
      done()