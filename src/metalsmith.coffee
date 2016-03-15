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

  Metalsmith: (opts, callback)->
    cfg.metalsmith = msp.readDataFiles 'source/data/*.*'
    cfg.runtime = {
      build: opts.build || false
      assets: cfg.metalsmith.metadata['assets-manifest']
    }

    MS cfg.site.path()
      .source      'source/site'
      .destination 'public'
      .clean        false
      .frontmatter  false

      .use msp.matters()
      .use msp.ignore(cfg.mp.ignore)
      .use msp.virtualPages(cfg.metalsmith.generators)
      .use msp.define(cfg.metalsmith.metadata)
      .use msp.metaPath()
      .use msp.inPlace(_.extend(cfg.mp.inPlace, msh))
      .use msp.rename(renameMap)
      .use msp.permalinks()
      .use msp.collections(cfg.fs.collections)

      .build (error)->
        if (error)
          callback(error)
        else
          gp.browserSync.reload()
          callback()
