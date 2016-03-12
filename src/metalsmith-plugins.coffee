# Metalsmith plugins (doh)
_      = require 'lodash'
marked = require 'marked'
path   = require 'path'

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
  msp.generatePages = (generators)->
    generatedPages = {}

    generateChildName = (filePath, childSlug)->
      parsed = path.parse filePath
      [parsed.dir, '/', parsed.name, '/', childSlug, parsed.ext].join('')

    doEval = (exp, self, parent)->
      'use strict';
      eval(exp)

    processPage = (filePath, content, parent)->
      children = {}
      metadata = {}
      templatify = []
      evaluate = []
      for key, value of content
        do (key, value)->
          switch key[-1..]
            when '/' then children[generateChildName filePath, key[0..-2]] = value
            when '_' then metadata[key[0..-2]] = marked value
            when '$' then metadata[key[0..-2]] = value; templatify.push key[0..-2]
            when '?' then metadata[key[0..-2]] = value; evaluate.push key[0..-2]
            else metadata[key] = value

      for key in evaluate
        do (key)->
          metadata[key] = doEval(metadata[key], metadata, parent)
      for key in templatify
        do (key)->
          tpl = _.template(metadata[key])
          console.log metadata.title, parent.title
          metadata[key] = tpl({ self: metadata, parent: parent });

      console.log metadata
      if Object.keys(children).length
        processPage filePath, content, metadata for filePath, content of children


    process = (generator, files)->
      for filePath, config of generator
        do (filePath, config)->
          processPage filePath, config

    (files, ms, done)->
      process generator, files for name, generator of generators
      done()

  return msp