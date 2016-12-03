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
  # THESE SHOULD BE IGNORED
  '.htaccess':
    contents: new Buffer('test')
    expected: '.htaccess'
  '.travis.yml':
    contents: new Buffer('test')
    expected: '.travis.yml'
  'CNAME':
    contents: new Buffer('test')
    expected: 'CNAME'
  'robots.txt':
    contents: new Buffer('test')
    expected: 'robots.txt'
  'sub/dir/another.txt':
    contents: new Buffer 'test'
    expected: 'sub/dir/another.txt'
  'google-xy12yt5f.htm':
    contents: new Buffer 'test'
    expected: 'google-xy12yt5f.htm'
  'sub/stuff.htm':
    contents: new Buffer 'test'
    expected: 'sub/stuff.htm'
  'this/is/ignored.jade':
    contents: new Buffer 'test'
    expected: '/path-to-site/source/ignored.jade'
  # THESE SHOULD WORK
  'index.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/index.jade'
  'second.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/second.jade'
  'third-with.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/third-with.jade'
  'fourth.php.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/fourth.php.jade'
  'fifth.html':
    contents: new Buffer('test')
    expected: 'fifth.html'
  'sixth.html.md':
    contents: new Buffer('test')
    expected: 'sixth.html.md'
  'sub/index.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/index.jade'
  'sub/sub2.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/sub2.jade'
  'sub/sub2-with.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/sub2-with.jade'
  'sub/subphp.php.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/subphp.php.jade'
  'sub/sub3.php.html':
    contents: new Buffer('test')
    expected: 'sub/sub3.php.html'
  'long/url/for/no/reason.txt.md.php.jade':
    contents: new Buffer('test')
    expected: '/path-to-site/source/reason.txt.md.php.jade'
  'long/url/for/no/other/reason.txt.md.php':
    contents: new Buffer('test')
    expected: 'long/url/for/no/other/reason.txt.md.php'


describe 'Pipeline files modifications', ()->
  before (beforeDone)->
    new smith __dirname
      .use (files, metalsmith, done)->
        delete files['nothing.txt']
        Object.keys(mockFiles).forEach (mockFile)->
          files[mockFile] = mockFiles[mockFile]
        done()
      .use msp.metaPath()
      .build (err, files)->
        mockFilesResult = files
        beforeDone()

  Object.keys(mockFiles).forEach (name)->
    it "should modify #{name} correctly", (done)->
      assert mockFilesResult[name], 'object', 'File exists'

      file = mockFilesResult[name]
      assert.equal file.filename, file.expected, 'Original file'
      done()
