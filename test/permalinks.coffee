# assert = require('chai').assert
# smith  = require 'metalsmith'
# _      = require 'lodash'

# mockConfig =
#   site:
#     path: (rel)->
#       "/path-to-site/#{rel}"

# metalsmithPlugins = require '../src/metalsmith-plugins'
# msp = metalsmithPlugins(null,null,smith,{},mockConfig)

# mockFilesResult = {}
# mockFiles =
#   # THESE SHOULDNT WORK
#   '.htaccess':
#     contents: new Buffer('test')
#     expected:
#       name: '.htaccess'
#       filename: '.htaccess'
#       url: '/.htaccess'
#   '.travis.yml':
#     contents: new Buffer('test')
#     expected:
#       name: '.travis.yml'
#       filename: '.travis.yml'
#       url: '/.travis.yml'
#   'CNAME':
#     contents: new Buffer('test')
#     expected:
#       name: 'CNAME'
#       filename: 'CNAME'
#       url: '/CNAME'
#   'robots.txt':
#     contents: new Buffer('test')
#     expected:
#       name: 'robots.txt'
#       filename: 'robots.txt'
#       url: '/robots.txt'
#   'sub/dir/another.txt':
#     contents: new Buffer 'test'
#     expected:
#       name: 'another.txt'
#       filename: 'another.txt'
#       url: '/another.txt'
#   'google-xy12yt5f.htm':
#     contents: new Buffer 'test'
#     permalink: false
#     expected:
#       name: 'google-xy12yt5f.htm'
#       filename: 'google-xy12yt5f.htm'
#       url: '/google-xy12yt5f.htm'
#   'sub/stuff.htm':
#     contents: new Buffer 'test'
#     permalink: false
#     expected:
#       name: 'sub/stuff.htm'
#       filename: 'sub/stuff.htm'
#       url: '/sub/stuff.htm'
#   'this/is/ignored.jade':
#     contents: new Buffer 'test'
#     permalink: false
#     expected:
#       name: 'this/is/ignored.jade'
#       filename: '/path-to-site/source/ignored.jade'
#       url: '/this/is/ignored.jade'
#   # THESE SHOULD WORK
#   'index.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'index.jade'
#       filename: '/path-to-site/source/index.jade'
#       url: '/'
#   'second.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'second/index.jade'
#       filename: '/path-to-site/source/second.jade'
#       url: '/second/'
#   'third-with.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'third-with/index.jade'
#       filename: '/path-to-site/source/third-with.jade'
#       url: '/third-with/'
#   'fourth.php.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'fourth/index.php.jade'
#       filename: '/path-to-site/source/fourth.php.jade'
#       url: '/fourth/'
#   'fifth.html':
#     contents: new Buffer('test')
#     expected:
#       name: 'fifth/index.html'
#       filename: 'fifth.html'
#       url: '/fifth/'
#   'sixth.html.md':
#     contents: new Buffer('test')
#     expected:
#       name: 'sixth/index.html.md'
#       filename: 'sixth.html.md'
#       url: '/sixth/'
#   'sub/index.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'sub/index.jade'
#       filename: '/path-to-site/source/index.jade'
#       url: '/sub/'
#   'sub/sub2.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'sub/sub2/index.jade'
#       filename: '/path-to-site/source/sub2.jade'
#       url: '/sub/sub2/'
#   'sub/sub2-with.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'sub/sub2-with/index.jade'
#       filename: '/path-to-site/source/sub2-with.jade'
#       url: '/sub/sub2-with/'
#   'sub/subphp.php.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'sub/subphp/index.php.jade'
#       filename: '/path-to-site/source/subphp.php.jade'
#       url: '/sub/subphp/'
#   'sub/sub3.php.html':
#     contents: new Buffer('test')
#     expected:
#       name: 'sub/sub3/index.php.html'
#       filename: 'sub/sub3.php.html'
#       url: '/sub/sub3/'
#   'long/url/for/no/reason.txt.md.php.jade':
#     contents: new Buffer('test')
#     expected:
#       name: 'long/url/for/no/reason/index.txt.md.php.jade'
#       filename: '/path-to-site/source/reason.txt.md.php.jade'
#       url: '/long/url/for/no/reason/'
#   'long/url/for/no/other/reason.txt.md.php':
#     contents: new Buffer('test')
#     expected:
#       name: 'long/url/for/no/other/reason/index.txt.md.php'
#       filename: 'long/url/for/no/other/reason.txt.md.php'
#       url: '/long/url/for/no/other/reason/'


# describe 'Pipeline files modifications', ()->
#   before (beforeDone)->
#     new smith __dirname
#       .use (files, metalsmith, done)->
#         delete files['nothing.txt']
#         Object.keys(mockFiles).forEach (mockFile)->
#           files[mockFile] = mockFiles[mockFile]
#         done()
#       .use msp.metaPath()
#       .build (err, files)->
#         mockFilesResult = files
#         beforeDone()

#   Object.keys(mockFiles).forEach (name)->
#     it "should modify #{name} correctly", (done)->
#       exp = mockFiles[name].expected
#       newName = exp.name
#       assert mockFilesResult[newName], 'object', 'Result file exists'

#       file = mockFilesResult[newName]
#       assert.equal file.origname, name, 'Original file'
#       assert.equal file.destname, newName, 'Indexed target name'
#       assert.equal file.filename, exp.filename, 'Filename for Jade or original'
#       assert.equal file.url, exp.url, 'Permalink URL'
#       done()
