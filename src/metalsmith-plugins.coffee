# Metalsmith plugins (doh)
_      = require 'lodash'
fs     = require 'fs'
glob   = require 'glob'
mm     = require 'multimatch'
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
      parsed.ext is '.jade'

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
    match = '**/*.{php,html,htm,jade,php.jade}';

    indexedName = (name, pathInfo)->
      pathParts = name.split('.')
      pathParts.shift()
      pathInfo.ext_ = '.' + pathParts.join('.')
      [ pathInfo.dir, ('/' if pathInfo.dir.length),
        pathInfo.name, '/index',
        pathInfo.ext_
      ].join ''

    setUrl = (filePath)->
      '/' + filePath

    setPermalink = (filePath)->
      pathParts = filePath.split('/')
      pathParts.splice(-1,1)
      path.normalize('/' + pathParts.join('/') + '/')

    (files, metalsmith, done)->
      matched = mm Object.keys(files), match
      for name, file of files
        # is this file good for /path/to/file/
        skipPermalink =
          matched.indexOf(name) is -1 ||
          (file.permalink? && !file.permalink)

        # do we need to move it around?
        unless skipPermalink or file.pathInfo.name is 'index'
          oldName = name
          name = indexedName(oldName, file.pathInfo)

          if Object.keys(files).indexOf(name) != -1
            throw new Error "File to permalink to exists already: #{name} (trying to move #{oldName})"

          delete files[oldName]
          files[name] = file

        # now we set URL to all files
        if skipPermalink
          files[name].url = setUrl name
        else
          files[name].url = setPermalink name
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