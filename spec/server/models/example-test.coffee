require (process.cwd() + '/config/application')

describe 'Models', ->
  before (done) ->
    done()

  it 'can test a model', (done) =>
    craft = chai.create 'craft'
    (expect craft.rank).to.eq 5
    done()
