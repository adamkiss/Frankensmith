# Metalsmith plugins (doh)
_      = require 'lodash'
fs     = require 'fs'
glob   = require 'glob'
mm     = require 'minimatch'
path   = require 'path'
matter = require 'gray-matter'
marked = require 'marked'

module.exports = (g, gp, ms, msp, cfg) ->
  ###
    Include metadata to files

    - parsed pathInfo (with pathInfo.ext_ - full ext)
    - filename (either path/to/file.ext, or full path for jade files)
  ###
  msp.metaPath = ()->
    pathParsePlus = (name)->
      parsed = path.parse name

      splitName = parsed.name.split('.')
      parsed.name = splitName.shift()

      nameExt = splitName.join '.'
      parsed.ext_ = ['.' if nameExt, nameExt, parsed.ext].join ''

      return parsed

    isJade = (parsed)->
      (parsed.ext.indexOf('jade') != -1)

    jadeFilename = (parsed)->
      cfg.site.path('source/' + parsed.base)

    process = (name, skipPermalink)->
      parsed = pathParsePlus name
      {
        pathInfo: parsed
        origname: name
        filename: if isJade(parsed) then jadeFilename(parsed) else name
      }

    (files, metalsmith, done)->
      for name, file of files
        _.merge file, process(name)
      done()

  ###
    Custom permalinks (and URL metadata)

    Adds permalinks to files, except if `permalink: false` is set or file matches exceptions.
  ###
  msp.permalinks = ()->
    match = '**/*.{php,html,htm}';

    indexedName = (parsed)->
      [ parsed.dir, ('/' if parsed.dir.length),
        parsed.name, ('/index' if parsed.name isnt 'index'),
        parsed.ext
      ].join ''

    permalink = (parsed)->
      [ '/',
        parsed.dir, ('/' if parsed.dir.length),
        (parsed.name + '/' if parsed.name isnt 'index')
      ].join ''

    (files, metalsmith, done)->
      matched = mm Object.keys(files), match
      for name, file in files
        skipPermalink =
          matched.indexOf(name) isnt -1 ||
          (file.permalink? && !file.permalink)
        if skipPermalink
          file.url
          if file.destname isnt name
            delete files[name]
            files[file.destname] = file


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