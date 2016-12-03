assert = require('chai').assert
smith  = require 'metalsmith'
_      = require 'lodash'

mockConfig =
  site:
    path: (rel)->
      "/path-to-site/#{rel}"

metalsmithPlugins = require '../src/metalsmith-plugins'
msp = metalsmithPlugins(null,null,smith,{},mockConfig)

mockFilesResult = {}
mockFiles =
  # THESE SHOULDNT WORK
  '.htaccess':
    contents: new Buffer('test')
    expected:
      name: '.htaccess'
      url: '/.htaccess'
  '.travis.yml':
    contents: new Buffer('test')
    expected:
      name: '.travis.yml'
      url: '/.travis.yml'
  'CNAME':
    contents: new Buffer('test')
    expected:
      name: 'CNAME'
      url: '/CNAME'
  'robots.txt':
    contents: new Buffer('test')
    expected:
      name: 'robots.txt'
      url: '/robots.txt'
  'sub/dir/another.txt':
    contents: new Buffer 'test'
    expected:
      name: 'sub/dir/another.txt'
      url: '/sub/dir/another.txt'
  'google-xy12yt5f.htm':
    contents: new Buffer 'test'
    permalink: false
    expected:
      name: 'google-xy12yt5f.htm'
      url: '/google-xy12yt5f.htm'
  'sub/stuff.htm':
    contents: new Buffer 'test'
    permalink: false
    expected:
      name: 'sub/stuff.htm'
      url: '/sub/stuff.htm'
  'this/is/ignored.html':
    contents: new Buffer 'test'
    permalink: false
    expected:
      name: 'this/is/ignored.html'
      url: '/this/is/ignored.html'
  # THESE SHOULD WORK
  'index.html':
    contents: new Buffer('test')
    expected:
      name: 'index.html'
      url: '/'
  'second.html':
    contents: new Buffer('test')
    expected:
      name: 'second/index.html'
      url: '/second/'
  'third-with.html':
    contents: new Buffer('test')
    expected:
      name: 'third-with/index.html'
      url: '/third-with/'
  'fourth.php':
    contents: new Buffer('test')
    expected:
      name: 'fourth/index.php'
      url: '/fourth/'
  'fifth.html':
    contents: new Buffer('test')
    expected:
      name: 'fifth/index.html'
      url: '/fifth/'
  'sixth.md.html':
    contents: new Buffer('test')
    expected:
      name: 'sixth/index.md.html'
      url: '/sixth/'
  'sub/index.html':
    contents: new Buffer('test')
    expected:
      name: 'sub/index.html'
      url: '/sub/'
  'sub/sub2.html':
    contents: new Buffer('test')
    expected:
      name: 'sub/sub2/index.html'
      url: '/sub/sub2/'
  'sub/sub2-with.html':
    contents: new Buffer('test')
    expected:
      name: 'sub/sub2-with/index.html'
      url: '/sub/sub2-with/'
  'sub/subphp.php':
    contents: new Buffer('test')
    expected:
      name: 'sub/subphp/index.php'
      url: '/sub/subphp/'
  'sub/sub3.php':
    contents: new Buffer('test')
    expected:
      name: 'sub/sub3/index.php'
      url: '/sub/sub3/'
  'long/url/for/no/reason.txt.md.php':
    contents: new Buffer('test')
    expected:
      name: 'long/url/for/no/reason/index.txt.md.php'
      url: '/long/url/for/no/reason/'
  'long/url/for/no/other/reason.txt.md.html':
    contents: new Buffer('test')
    expected:
      name: 'long/url/for/no/other/reason/index.txt.md.html'
      url: '/long/url/for/no/other/reason/'


describe 'Pipeline files modifications', ()->
  before (beforeDone)->
    new smith __dirname
      .use (files, metalsmith, done)->
        delete files['nothing.txt']
        Object.keys(mockFiles).forEach (mockFile)->
          files[mockFile] = mockFiles[mockFile]
        done()
      .use msp.metaPath()
      .use msp.permalinks()
      .build (err, files)->
        if err
          beforeDone(err)
        else
          mockFilesResult = files
          beforeDone()

  Object.keys(mockFiles).forEach (name)->
    it "should modify #{name} correctly", (done)->
      exp = mockFiles[name].expected
      newName = exp.name
      assert mockFilesResult[newName], 'object', 'File with expected name'

      assert.equal mockFilesResult[newName].url, exp.url, 'Permalink URL'
      done()