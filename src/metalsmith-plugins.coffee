# Metalsmith plugins (doh)
_      = require 'lodash'
fs     = require 'fs'
glob   = require 'glob'
path   = require 'path'
matter = require 'gray-matter'
marked = require 'marked'

module.exports = (g, gp, ms, msp, cfg) ->
  ###
    Include metadata to files

    - filename (either path/to/file.ext, or full path for jade files)
    - url (clean URL: /path/to/file/)
  ###
  class File
    @file

    constructor: (name, contents)->
      contents.path.original = name
      @file = contents
      @name = path.parse name

    isJade: ()->
      console.log @name


  msp.metaPath = ()->
    isJade = (name)->
      (name.indexOf('.jade') != -1)

    jadeFilename = (name)->
      cfg.site.path 'source/' + name.split('/').pop()

    indexify = (name)->
      name

    process = (name)->
      {
        destname: indexify(name)
        filename: if isJade(name) then jadeFilename(name) else name
        url: name.split('.')[0]
      }

    (files, metalsmith, done)->
      for name, file of files
        update = process name
        _.merge file, update
        if file.destname isnt name
          delete files[name]
          files[file.destname] = file
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