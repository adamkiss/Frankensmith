# Metalsmith plugins (doh)
_ = require 'lodash'

module.exports = (g, gp, ms, msp, cfg) ->
  ###
    Prepend path for jade

    JADE works with root from metalsmith, so it ignores the 'source dir'. We need to set virtual filename of JADE-parsed files to __ROOT__/site/xxx.jade, so we can include and extend files with root of ./site/***
  ###
  msp.pathForJade = ()->
    setPath = (name, files)->
      if name.indexOf('.jade') != -1
        files[name].filename = cfg.site.path name.split('/').pop()

    (files, metalsmith, done)->
      setPath name, files for name, file of files
      done()


  ###
    Generate pages

    Generates pages from virtual source (= yaml/json/other gray-matter supported files).
  ###
  class VirtualFile
    @path       # key for metalsmith
    @metadata   # metadata
    @content    # base for buffer
    @children   # children of this page

    constructor: (path, object)->
      console.log path, object

    get: ()->
      _.extend(@metadata, {contents: new Buffer @content})
      @metadata

  msp.generatePages = (generators)->
    generatedPages = {}

    process = (generator, files)->
      virtualFiles = {}
      for path, config of generator
        do (path, config)->
          newFile = new VirtualFile path, config
          _.extend virtualFiles, newFile

    (files, ms, done)->
      process generator, files for name, generator of generators
      done()

  return msp