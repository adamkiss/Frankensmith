module.exports = ()->
  path = require 'path'

  class Directory
    constructor: (@_path)->

    path: (relative_path)->
      rel = if relative_path? then "/#{relative_path}" else ''
      @_path + rel

    to: (from)->
      path.relative @_path, from

  config = { 
    self: new Directory process.cwd()
    site: new Directory process.env.INIT_CWD
    gp:
      jshint:
        node: true
        esnext: true
        bitwise: true
        curly: true
        immed: true
        newcap: true
        noarg: true
        undef: true
        unused: 'vars'
      sass:
        build:
          outputStyle:    'compressed'
          sourceComments:  false
          errLogToConsole: true
        serve:
          sourceMap:         true
          sourceMapContents: true
          sourceComments:   'none'
          errLogToConsole:   true
      imagemin:
        progressive: true
    mp:
      ignore: [
        '.DS_Store'
      ]
      inPlace:
        engine: 'jade'
        cache : false
        pattern: '*.jade*'
  }

  config.fs = require(config.site.path 'site.js')()

  return config