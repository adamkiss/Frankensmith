module.exports = (g, gp, cfg)->

  _   = require 'lodash'
  MS  = require 'metalsmith'
  msp = require('load-metalsmith-plugins')()
  msh = require('./metalsmith-helpers')(g, gp, MS, msp, cfg)
  msp = require('./metalsmith-plugins')(g, gp, MS, msp, cfg)

  renameMap = [
    [/\.php\.jade$/, '.php'],
    [/\.jade$/     , '.htm']
  ]

  dataFiles = (relativePath)->
    fs = require 'fs'
    matter = require 'gray-matter'
    glob = require 'glob'
    path = require 'path'

    returnData =
      generators: {}
      metadata: {}

    glob.sync(cfg.site.path(relativePath)).forEach (file)->
      fileParts = path.parse(file).name.split('_')
      fileData = matter("---\n"+fs.readFileSync(file)).data
      if fileParts[0] is 'generator'
        _.set(returnData.generators, fileParts.slice(1).join('.'), fileData)
      else
        _.set(returnData.metadata, fileParts.join('.'), fileData)

    return returnData

  Metalsmith: (opts, callback)->
    cfg.metalsmith = dataFiles 'data/*.*'

    cfg.runtime = {
      build: opts.build || false
      assets: cfg.metalsmith.metadata['assets-manifest']
    }

    MS cfg.site.path()
      .source      'source'
      .destination 'public'
      .clean        false
      .frontmatter  false

      .use msp.matters()
      .use msp.ignore(cfg.mp.ignore)
      .use msp.generatePages(cfg.metalsmith.generators)
      .use msp.define(cfg.metalsmith.metadata)
      .use msp.filenames()
      .use msp.pathForJade()
      .use msp.inPlace(_.extend(cfg.mp.inPlace, msh))
      .use msp.rename(renameMap)

      .build (error)->
        if (error)
          callback(error)
        else
          gp.browserSync.reload()
          callback()
