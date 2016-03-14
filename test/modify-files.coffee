should = require('chai').should()
smith  = require 'metalsmith'
_      = require 'lodash'

mockConfig =
  site:
    path: (rel)->
      "/path-to-site/#{rel}"

metalsmithPlugins = require '../src/metalsmith-plugins'
msp = metalsmithPlugins(null,null,smith,{},mockConfig)

mockFiles =
  'index.jade':
    contents: new Buffer('test')
    expected:
      name: 'index.jade'
      filename: '/path-to-site/source/index.jade'
      url: '/'
  'second.jade':
    contents: new Buffer('test')
    expected:
      name: 'second/index.jade'
      filename: '/path-to-site/source/second.jade'
      url: '/second/'
  'third-with.jade':
    contents: new Buffer('test')
    expected:
      name: 'third-with/index.jade'
      filename: '/path-to-site/source/third-with.jade'
      url: '/third-with/'
  'fourth.php.jade':
    contents: new Buffer('test')
    expected:
      name: 'fourth/index.php.jade'
      filename: '/path-to-site/source/index.jade'
      url: '/fourth/'
  'sub/index.jade':
    contents: new Buffer('test')
    expected:
      name: 'index.jade'
      filename: '/path-to-site/source/index.jade'
      url: '/'
  'sub/sub2.jade':
    contents: new Buffer('test')
    expected:
      name: 'sub/sub2/index.jade'
      filename: '/path-to-site/source/sub2.jade'
      url: '/sub/sub2/'
  'sub/sub2-with.jade':
    contents: new Buffer('test')
    expected:
      name: 'sub/sub2-with/index.jade'
      filename: '/path-to-site/source/index.jade'
      url: '/sub/sub2-with/'
  'sub/sub2.php.jade':
    contents: new Buffer('test')
    expected:
      name: 'sub/sub2/index.jade'
      filename: '/path-to-site/source/sub2.php.jade'
      url: '/sub/sub2/'
  'long/url/for/no/reason.txt.md.php.jade':
    contents: new Buffer('test')
    expected:
      name: 'long/url/for/no/reason/index.txt.md.php.jade'
      filename: '/path-to-site/source/index.txt.md.php.jade'
      url: '/long/url/for/no/reason/'


describe 'Pipeline files modifications', ()->
  before (beforeDone)->
    new smith __dirname
      .clean false
      .use (files, metalsmith, done)->
        delete files['nothing.txt']
        Object.keys(mockFiles).forEach (mockFile)->
          files[mockFile] = mockFiles[mockFile]
        done()
      .use msp.fileModifier()
      .build (err, files)->
        beforeDone()

  Object.keys(mockFiles).forEach (name)->
    it "should modify #{name} correctly", (done)->
      name.should.be.equal mockFiles[name].expected.name
      mockFiles[name].filename.should.be.equal mockFiles[name].expected.filename
      mockFiles[name].url.should.be.equal mockFiles[name].expected.url
      done()