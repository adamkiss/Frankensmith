# Metalsmith plugins (doh)
_      = require 'lodash'
fs     = require 'fs'
glob   = require 'glob'
path   = require 'path'
matter = require 'gray-matter'
marked = require 'marked'

module.exports = (g, gp, ms, msp, cfg) ->
  ###
    Prepend path for jade

    JADE works with root from metalsmith, so it ignores the 'source dir'. We need to set virtual filename of JADE-parsed files to __ROOT__/site/xxx.jade, so we can include and extend files with root of ./site/***
  ###
  msp.pathForJade = ()->
    setPath = (name, files)->
      if name.indexOf('.jade') != -1
        files[name].filename = cfg.site.path 'source/' + name.split('/').pop()

    (files, metalsmith, done)->
      setPath name, files for name, file of files
      done()

  ###
    Read data file

    Reads data files, based on first part of name (generator / anything) splits them into
    generators for virtual pages and metadata to include
  ###
  msp.readDataFiles = (relativePath)->
    returnData =
      generators: []
      metadata: {}

    glob.sync(cfg.site.path relativePath).forEach (file)->
      fileParts = path.parse(file).name.split('_')
      fileData = matter( "---\n" + fs.readFileSync file ).data

      if fileParts[0] is 'generator'
        returnData.generators.push fileData
      else
        _.set(returnData.metadata, fileParts.join('.'), fileData)

    return returnData
  ###
    Return

    This banner is here just to visually separate things.
  ###
  return msp