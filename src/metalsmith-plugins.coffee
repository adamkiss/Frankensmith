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
  msp.metaPath = ()->
    pathParsePlus = (name)->
      parsed = path.parse name

      splitName = parsed.name.split('.')
      parsed.name = splitName.shift()

      nameExt = splitName.join '.'
      parsed.ext = ['.' if nameExt, nameExt, parsed.ext].join ''

      return parsed

    isJade = (parsed)->
      (parsed.ext.indexOf('jade') != -1)

    jadeFilename = (parsed)->
      cfg.site.path('source/' + parsed.base)

    buildName = (parsed)->
      [ parsed.dir, ('/' if parsed.dir.length),
        parsed.name, ('/index' if parsed.name isnt 'index'),
        parsed.ext
      ].join ''

    permalink = (parsed)->
      [ '/',
        parsed.dir, ('/' if parsed.dir.length),
        (parsed.name + '/' if parsed.name isnt 'index')
      ].join ''

    process = (name)->
      parsed = pathParsePlus name
      {
        origname: name
        destname: buildName(parsed)
        filename: if isJade(parsed) then jadeFilename(parsed) else name
        url: permalink(parsed)
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