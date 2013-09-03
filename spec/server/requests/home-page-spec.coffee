require (process.cwd() + '/config/application')

# see http://chaijs.com/plugins/chai-http
# see https://github.com/visionmedia/superagent

describe 'Requests', ->
  @timeout = -> 4000

  before (done) ->
    done()

  it 'can test a request', (done) ->
    chai.request(app)
      .get('/')
      .res (res)=>
        (expect res).to.have.status(200);
        (expect res).to.be.html;
        (expect res.text).to.not.be.empty
        done()